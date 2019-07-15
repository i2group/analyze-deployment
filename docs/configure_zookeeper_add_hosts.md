# Adding other ZooKeeper servers
You can add extra servers to your distributed deployment to host ZooKeeper servers. This section describes the process of creating new Docker containers that represent the extra servers, and hosting a ZooKeeper server on each server.

## Overview
ZooKeeper is used to manage the SolrCloud configuration. To increase the resilience of ZooKeeper, an ensemble of ZooKeeper servers is deployed. When a majority of servers are connected, the ZooKeeper ensemble is working and enables SolrCloud to function.  

A ZooKeeper ensemble is usually made up of an odd number of ZooKeeper servers. For more information about ZooKeeper, ZooKeeper servers, and ZooKeeper ensembles, see [Setting Up an External ZooKeeper Ensemble](https://lucene.apache.org/solr/guide/6_6/setting-up-an-external-zookeeper-ensemble.html).

## Before you begin
- If you deployed the example with one of the configurations in the `configuration_mods` directory or changed the `topology.xml` file. Reset your example deployment to the base configuration before you add other ZooKeeper servers. To reset your environment, run the following command from the `src/scripts` directory:
```
./resetEnvironment
```

- Create two directories that are named `zookeeper2` and `zookeeper3` in the `src/images/common` directory, and copy the contents of the `src/images/common/zookeeper` directory into the new `zookeeper2` and `zookeeper3` directories.

## Modifying the `Dockerfiles`
In the Docker environment, create two more containers to represent the extra servers. The new containers are copies of the ZooKeeper container, which are modified to use a different host name and port.

Modify the `Dockerfile` in the `zookeeper2` directory to specify the host name and port to expose:

- Set the `ENV` instruction to `ENV hostname zookeeper2`.  
This is the host name of the new container.

- Set the `EXPOSE` instruction to `EXPOSE 9984`.  
This is the port that is exposed to enable connection to ZooKeeper from the host machine.

Modify the `Dockerfile` in the `zookeeper3` directory to specify the host name and port to expose:

- Set the `ENV` instruction to `ENV hostname zookeeper3`.  
This is the host name of the new container.

- Set the `EXPOSE` instruction to `EXPOSE 9984` for zookeeper2 and `EXPOSE 9985` for zookeeper3.  
This is the port that is exposed to enable connection to ZooKeeper from the host machine.

## Adding the ZooKeeper servers to the `topology.xml`
Modify the `topology.xml` file in the `src/images/common/zookeeper2/configuration/environment` and `src/images/common/zookeeper3/configuration/environment` directories to include the new ZooKeeper host ports that are specified in the `Dockerfile`.  

>Note: If all of your servers are intended to run on separate machines, you can configure them to use the same port numbers.

Add the following `<zkhost>` elements as children of the `<zkhosts>` element:
```
<zkhost quorum-port-number="10484" leader-port-number="10984" data-dir="/opt/IBM/i2analyze/data/zookeeper" host-name="zookeeper2" id="2" port-number="9984"/>
<zkhost quorum-port-number="10485" leader-port-number="10985" data-dir="/opt/IBM/i2analyze/data/zookeeper" host-name="zookeeper3" id="3" port-number="9985"/>
```

Make the same modification to the `topology.xml` file in the `src/configuration/environment` directory to ensure that the configuration is consistent.

## Build and create the ZooKeeper containers
Build the ZooKeeper image, run the following commands from the `src/images` folder:
```
docker build -t zookeeper2_image /common/zookeeper2
docker build -t zookeeper3_image /common/zookeeper3
```
The `zookeeper2` and `zookeeper3` images are created. Inspect the `Dockerfiles` in the `src/images/common/zookeper2` and `src/images/common/zookeeper3` directories to see the commands that are required to configure the ZooKeeper servers.

Run the ZooKeeper containers:
```
docker run -d --name zookeeper2 -p 9984:9984 --net eianet -u root zookeeper2_image
docker run -d --name zookeeper3 -p 9985:9985 --net eianet -u root zookeeper3_image
```
Check that the containers started correctly by using the docker logs:
```
docker logs -f zookeeper2
docker logs -f zookeeper3
```
The image includes the `topology.xml` file that you modified, and defines the values for the configuration of the new ZooKeeper servers. When the containers start, the new ZooKeeper servers are created on the new servers.

## Adding the additional ZooKeeper servers to the deployment
When you add ZooKeeper servers to an ensemble, your search index becomes unavailable for the time that it takes to update the configuration on your existing ZooKeeper servers, restart them, and restart any Solr nodes.

The i2 Analyze configuration is changed since the initial ZooKeeper server was started. You must copy the new configuration to the initial ZooKeeper server.

In a Docker environment, use the Docker `cp` command to copy, and overwrite, your configuration to the running `zookeeper` container. In the `src` directory, run the following command:
```
docker cp ./configuration zookeeper:/opt/IBM/i2analyze/toolkit/
```
The new configuration is now on the `zookeeper` container.

When the directory is copied, the owner of the directory, and all files within it, is changed. The user that runs the deployment script must be able to write to files within the `configuration` directory. To change the ownership of the directory and the files, run the following command:
```
docker exec -u root zookeeper chown -R i2analyze:i2analyze /opt/IBM/i2analyze/toolkit/configuration
```

In a non-Docker environment, copy the modified `topology.xml` file to the same location in your i2 Analyze toolkit on the ZooKeeper server.
It is a good idea to keep all of the server's configurations in step. Copy the `configuration` directory to all of the containers that require a configured i2 Analyze toolkit.

Restart the initial ZooKeeper server by running the following command:
```
docker exec -u i2analyze -d zookeeper /opt/IBM/i2analyze/toolkit/scripts/setup -t restartZkHosts --hostname zookeeper
```

Check that the ZooKeeper servers started as an ensemble, and not as stand-alone servers, by running the following command:
```
docker exec -u i2analyze -t zookeeper /opt/IBM/i2analyze/toolkit/scripts/setup -t getZkStatus
```
This outputs the status of all of the ZooKeeper servers in the ensemble, it also shows which ZooKeeper servers are the followers and which is the leader. The output might look like the following message:
```
Status: Zookeeper version: 3.4.10-39d3a4f269333c922ed3db283be479f9deacaa0f, built on 03/23/2017 10:13 GMT
Latency min/avg/max: 0/3/6
Received: 14
Sent: 13
Connections: 1
Outstanding: 0
Zxid: 0x10000000c
Mode: follower
Node count: 8

Zookeeper status check on zookeeper2:9984

Status: Zookeeper version: 3.4.10-39d3a4f269333c922ed3db283be479f9deacaa0f, built on 03/23/2017 10:13 GMT
Latency min/avg/max: 0/0/0
Received: 7
Sent: 6
Connections: 1
Outstanding: 0
Zxid: 0x10000000c
Mode: follower
Node count: 8

Zookeeper status check on zookeeper3:9985

Status: Zookeeper version: 3.4.10-39d3a4f269333c922ed3db283be479f9deacaa0f, built on 03/23/2017 10:13 GMT
Latency min/avg/max: 0/0/0
Received: 9
Sent: 8
Connections: 1
Outstanding: 0
Zxid: 0x10000000c
Mode: leader
Node count: 8


Zookeeper status reported okay
```
In this example, `zookeeper3` is the leader of the ZooKeeper ensemble, and `zookeeper` and `zookeeper2` are the followers.

The initial ZooKeeper server must have access to the other ZooKeeper servers. To provide access, you must update the `zoo.cfg` file with the modified topology of the deployment. Run the following command to update the configuration:
```
docker exec -u i2analyze -it zookeeper /opt/IBM/i2analyze/toolkit/scripts/setup -t createZkHosts --hostname zookeeper
```
The `zoo.cfg` file in the `zookeeper` container now has the details for the other ZooKeeper servers in the ensemble.  
When this toolkit task is run, the ZooKeeper server is stopped. The running Solr nodes rely on the initial ZooKeeper, and they are effectively down until the ZooKeeper host is started again.

The new configuration file must be uploaded to ZooKeeper by running the following command:
```
docker exec -u i2analyze -it zookeeper /opt/IBM/i2analyze/toolkit/scripts/setup -t createAndUploadSolrConfig --hostname zookeeper
```
This command also starts the ZooKeeper server.

## Updating the Solr configuration
The i2 Analyze configuration has changed since the Solr servers started to include the additional ZooKeeper hosts. The updated configuration must be copied to the Solr servers.

In a Docker environment, use the Docker `cp` command to copy, and overwrite, your configuration to the running `solr` and `solr2` containers. In the `src` directory, run the following commands:
```
docker cp ./configuration solr:/opt/IBM/i2analyze/toolkit/
docker cp ./configuration solr2:/opt/IBM/i2analyze/toolkit/
```
The new configuration is now on the `solr` and `solr2` containers.

When the directory is copied, the owner of the directory, and all files within it, is changed. The user that runs the deployment script must be able to write to files within the `configuration` directory. To change the ownership of the directory and the files, run the following command:
```
docker exec -u root solr chown -R i2analyze:i2analyze /opt/IBM/i2analyze/toolkit/configuration
docker exec -u root solr2 chown -R i2analyze:i2analyze /opt/IBM/i2analyze/toolkit/configuration
```

To update the Solr configuration on the Solr nodes, restart the nodes by running the following commands:
```
docker exec -u i2analyze -t solr /opt/IBM/i2analyze/toolkit/scripts/setup -t restartSolrNodes --hostname solr
docker exec -u i2analyze -t solr2 /opt/IBM/i2analyze/toolkit/scripts/setup -t restartSolrNodes --hostname solr2
```
## Updating Liberty
The Liberty server requires the updated `topology.xml` file that defines the new ZooKeeper servers.

In a Docker environment, use the Docker `cp` command to copy, and overwrite, your configuration to the running `liberty` container. In the `src` directory, run the following commands:
```
docker cp ./configuration liberty:/opt/IBM/i2analyze/toolkit/
```
The new configuration is now on the `liberty` container.

When the directory is copied, the owner of the directory, and all files within it, is changed. The user that runs the deployment script must be able to write to files within the `configuration` directory. To change the ownership of the directory and the files, run the following command:
```
docker exec -u root liberty chown -R i2analyze:db2iusr1 /opt/IBM/i2analyze/toolkit/configuration
```

Restart the application server by running the following command:
```
docker exec -u i2analyze -d liberty /opt/IBM/i2analyze/toolkit/scripts/setup -t restartLiberty
```

## Testing the ZooKeeper ensemble
To test that ZooKeeper is working as an ensemble, you can shut down one of the ZooKeeper servers and check the status of the ensemble:
```
docker exec -u i2analyze -t zookeeper /opt/IBM/i2analyze/toolkit/scripts/setup -t stopZkHosts --hostname zookeeper
docker exec -u i2analyze -t zookeeper /opt/IBM/i2analyze/toolkit/scripts/setup -t getZkStatus
```
After the ZooKeeper server is stopped, the `getZkStatus` toolkit task reports that the other two servers are running and serving requests.

The status of the stopped `zookeeper` server is `Connection refused`, as follows:
```
Zookeeper status check on zookeeper:9983
Error: java.net.ConnectException: Connection refused (Connection refused)
```

If you stop enough ZooKeeper servers so that there is no longer a working majority, the remaining active ZooKeeper servers are not available to serve requests. If you run the `getZkStatus` toolkit task, the output reports as follows:
```
Zookeeper status check on zookeeper:9983
Error: java.net.ConnectException: Connection refused (Connection refused)
Zookeeper status check on zookeeper2:9984
Error: java.net.ConnectException: Connection refused (Connection refused)
Zookeeper status check on zookeeper3:9985

Status: This ZooKeeper instance is not currently serving requests
```

To test that the Solr nodes are configured with to use the new ZooKeeper servers, you can look at the **Java properties** tab in the Solr Web UI. The **zkHost** property shows the ZooKeeper servers. All 3 of the ZooKeeper servers in your deployment are listed.

To test the resilience of the system stop the initial ZooKeeper server, by running the following command:
```
docker exec -u i2analyze -t zookeeper /opt/IBM/i2analyze/toolkit/scripts/setup -t stopZkHosts --hostname zookeeper
```
After it is shut down, look at the Solr Web UI to check that the Solr servers are still operational and that the Solr collection is still running.

You can test that the search index is working by running a Quick Search in i2 Analyst's Notebook Premium.

To restart the ZooKeeper server, run the following command:
```
docker exec -u i2analyze -d zookeeper /opt/IBM/i2analyze/toolkit/scripts/setup -t startZkHosts --hostname zookeeper
```
