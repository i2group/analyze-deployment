# Adding another Solr server and Solr node
You can add an extra Solr server to your distributed deployment. This section describes the process of creating a new Docker container that represents the extra Solr server, and adding a Solr node on that server to the existing Solr collection.

## Before you begin
Create a directory named `solr3` in the `src/images/common` directory, and copy the contents of the `src/images/common/solr` directory into the new `solr3` directory.

## Modifying the `Dockerfile`
In the Docker environment, create another container to represent the extra server. The new container is a copy of the Solr container, which is modified to use a different host name and port.

Modify the `Dockerfile` in the `src/images/common/solr3` directory to specify the host name and port to expose:

Set the `ARG` instruction to `ARG hostname=solr3`.  
This is the host name of the new container.

Set the `EXPOSE` instruction to `EXPOSE 8985`.  
This is the port that is exposed to enable a connection the Solr web UI.

## Adding the Solr node to the `topology.xml`
Modify the `topology.xml` in the `src/images/common/solr3/configuration/environment` directory to include the new host name and ports that are specified in the `Dockerfile`.  
Add the following `<solr-node>` element as a child of the `<solr-nodes>` element:
```
<solr-node memory="512m" data-dir="/opt/IBM/i2analyze/data/solr" host-name="solr3" id="node3" port-number="8985"/>
```
Make the same modification to the `topology.xml` in the `src/configuration/environment` directory to ensure that the configuration is consistent.

## Build and create the Solr container
Build the Solr image, run the following command from the `src/images/common` folder:
```
docker build -t solr3_image solr3
```
The Solr image is created with the name `solr3_image`. Inspect the `Dockerfile` in the `src/images/common/solr3` directory to see the commands that are required to configure the Solr server.

Run the Solr3 container:
```
docker run -d --name solr3 -p 8985:8985 --net eianet --memory=2g -u i2analyze solr3_image
```
Check that the container started correctly by using the docker logs:
```
docker logs -f solr3
```
The image includes the `topology.xml` file that you modified, and defines the values for the configuration of the new Solr node. When the server starts, the new Solr node is created on the new server.

When you start the Solr container, the port that Solr runs on in the container is specified. The specified port is mapped on the host machine so that you can access Solr and the Solr Web UI from the host machine.

After the Solr node is running, you can use the Solr Web UI to inspect the configuration. Connect to the Solr Web UI on the `solr` container. In a web browser, go to the following URL to connect to the Solr Web UI: <http://localhost:8983/solr/#>. The user name is `solradmin` and the password is the Solr password set in the `credentials.properties` file.

## What to do next
After you create the Solr node, you can configure your Solr collection to use the new node by adding a shard or replica to the node. For more information, see [Adding Solr shards to your deployment](configure_solr_add_shard.md), and [Adding Solr replicas to your deployment](configure_solr_add_replica.md).
