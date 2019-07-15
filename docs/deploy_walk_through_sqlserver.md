# Deploying the distributed deployment example manually
The manual deployment of the distributed deployment example requires you to run each of the steps that were completed automatically in the Quick deploy. The following instructions detail what steps are required on each container, and how to use these steps to deploy i2 Analyze on physical servers.

>**Important**: The distributed example uses a Docker environment to demonstrate a distributed deployment of i2 Analyze. The Docker environment is not designed to be used on customer sites for test or production systems. After you understand how the distributed deployment is deployed, replicate the deployment on physical servers.

## Before you begin
- Complete the [Quick deploy](deploy_quick_start.md) section at least once, before you start the manual deployment. The software prerequisites that you download for the Quick deploy are also used here.
- Complete the [Clean your environment](deploy_clean_environment.md) section to ensure that none of the images, containers, or network exist.

You must run all Docker commands from a command line where Docker is initialized.

>For Windows 7, you must also forward the required ports from your local workstation to the virtual machine that hosts Docker.
>
>In the network settings for your docker virtual machine, open the **Advanced** menu and click **Port Forwarding**. Create a new line, and enter values for the `Host IP`, `Host Port`, and `Guest Port`. You must do this for each port that is exposed in the Docker environment.

## Create the network
To enable communication between the docker containers, all the containers must be connected to a single network. You can create a bridge network that only the docker containers can access. When each container is run, the `--net` flag is used to specify that the container connects to a specific network.

Create a bridge network called `eianet` for the distributed deployment example:
```
docker network create eianet
```
Test that the network is created:
```
docker network ls
```
The `eianet` network is displayed in the list.

In a non-Docker environment, ensure that each server that you are using to deploy i2 Analyze can connect to each other.

## Copy the i2 Analyze configuration
The i2 Analyze configuration is required by all servers that host components of i2 Analyze, except for the database server. In the `src/scripts` directory of the distributed deployment example, the `copyConfiguration` script copies the i2 Analyze configuration from the `src/configuration` directory to the `<container_name>/configuration` directory for each container.

From the `src/scripts` directory, run the `copyConfiguration` script file.
```
./copyConfiguration
```

### Results
In a non-Docker environment, copying the configuration is equivalent to the following steps:  
Download and extract the i2 Analyze toolkit onto a server.

Copy the `examples/configurations/information-store-opal/configuration` directory into the `toolkit` directory of your extracted i2 Analyze toolkit.

You must populate the configuration for your environment, use the `src/configuration` directory as a reference. This is the centralized i2 Analyze toolkit and configuration that you copy to your servers.

---

## Build the prerequisite images
In the distributed deployment example, some of the images are built on top of other images. The prerequisite images must be built first, as described in the following section.

### Ubuntu toolkit image
The `ubuntu_toolkit_image` is an image that contains the Ubuntu operating system with i2 Analyze installed and contains the i2 Analyze configuration.

When you build the `ubuntu_toolkit_image`, the `i2analyze.tar.gz` that you copied into the `src/images/common/ubuntu_toolkit/i2analyze` directory as part of the Quick deploy is copied and extracted into the image.

To build the Ubuntu toolkit image, run the following from the `src/images/common` folder:
```
docker build -t ubuntu_toolkit_image ubuntu_toolkit
```
The Ubuntu toolkit image is created with the name `ubuntu_toolkit_image`.

---

## Configuring and running the containers
Each Docker container requires a Docker image. In a non-Docker environment, this is equivalent to configuring and starting a physical server that is used to host a component of i2 Analyze.

### SQL Server container
The SQL Server container is built from an image that is available from Microsoft on Docker hub, [https://hub.docker.com/_/microsoft-mssql-server](https://hub.docker.com/_/microsoft-mssql-server).

To build the `sqlserver` image, run the following command from the `src/images/sqlserver`:
```
docker build -t sqlserver_image sqlserver
```

Run the SQL Server container:
```
docker run -d -e 'ACCEPT_EULA=Y' -e "SA_PASSWORD=<SAPassword>" --name sqlserver -p 1433:1433 --net eianet sqlserver_image
```
Where `<SAPassword>` is a password for the system administrator user for the SQL Server container.

Run the following command to add the i2 Analyze user with the required permissions:
```
docker exec -t sqlserver /opt/mssql-tools/bin/sqlcmd -U SA -P <SAPassword> -Q "CREATE LOGIN i2analyze WITH PASSWORD = '<Password>'; CREATE USER i2analyze FOR LOGIN i2analyze; ALTER SERVER ROLE sysadmin ADD MEMBER i2analyze"
```
Where `<SAPassword>` is the same password that you entered in the previous command, and `<Password>` is the password that you specified in the `credentials.properties` file for the `db.infostore.password` credential.

The container is started with SQL Server installed and running. The port number of the SQL Server instance is `1433`.

### ZooKeeper container
ZooKeeper is the service that is used to maintain configuration information and distributed synchronization across Solr. In this deployment, ZooKeeper is deployed on its own server. Your configured i2 Analyze toolkit must be installed on the ZooKeeper server.

To build the `zookeeper` image, run the following command from the `src/images/common` folder:
```
docker build -t zookeeper_image zookeeper
```
Run the ZooKeeper container:
```
docker run -d --name zookeeper --net eianet -u i2analyze zookeeper_image
```
Then, check that ZooKeeper started correctly by using the docker logs:
```
docker logs -f zookeeper
```
Inspect the [`Dockerfile`](../src/images/common/zookeeper/Dockerfile) in the `src/images/common/zookeeper` directory to see the commands that are required to configure a ZooKeeper server in a non-Docker environment.

The ZooKeeper container is started. The container starts and configures ZooKeeper, and hosts the ZooKeeper server. The `topology.xml` file in the i2 Analyze configuration defines the values for the ZooKeeper server.

### Solr containers
Solr is used to manage the search index in a deployment of i2 Analyze. In this deployment, Solr is distributed across two servers. Your configured i2 Analyze toolkit must be installed on each Solr server.

To build the Solr images, run the following commands from the `src/images/common` folder:
```
docker build -t solr_image solr
docker build -t solr2_image solr2
```

The Solr images are created with the names `solr_image` and `solr2_image`.

Run the Solr containers:
```
docker run -d --name solr -p 8983:8983 --net eianet -u i2analyze solr_image
docker run -d --name solr2 -p 8984:8984 --net eianet -u i2analyze solr2_image
```

Check that the containers started correctly by using the docker logs:
```
docker logs -f solr
docker logs -f solr2
```

Inspect the [`Dockerfile`](../src/images/common/solr/Dockerfile) in `src/images/common/solr` and the [`Dockerfile`](../src/images/common/solr2/Dockerfile) in `src/images/common/solr2` to see the commands that are required to configure a Solr server in a non-Docker environment.

The images include an i2 Analyze `topology.xml` file that defines the values for the configuration of Solr. When the server starts, the appropriate Solr nodes are started.

When you start the Solr container, the port that Solr runs on in the container is specified, in this example it is either `8983` or `8984`. The specified port is mapped on the host machine so that you can access Solr and the Solr Web UI from the host machine.

After the Solr nodes are running, you can use the Solr Web UI to inspect the Solr and ZooKeeper configurations. Connect to the Solr Web UI on the `solr` container. In a web browser, go to the following URL to connect to the Solr Web UI: [http://localhost:8983/solr/#](http://localhost:8983/solr/#). The user name is `solradmin` and the password is the Solr password set in the `credentials.properties` file.  
>Where the port number is the same as the one that is mapped to local machine when the Solr container is run.
>The URL uses `localhost` because the `8983` port is mapped from the host machine to the docker container. In a non-Docker environment, connect by using the host name of the Solr server.

### Admin client container
In this deployment, the Admin client is a separate server that is designed for running toolkit tasks in a distributed environment. Your configured i2 Analyze toolkit, and a Db2 client must be installed on the server that you want to use to interact with Liberty and Db2.

To build the Admin client image, run the following command from the `src/images/sqlserver` folder:
```
docker build -t admin_client_sqlserver_image admin_client
```
The Admin client image is created with the name `admin_client_sqlserver_image`.

Run the Admin client container:
```
docker run -d --name admin_client --net eianet -u i2analyze admin_client_sqlserver_image
```
Inspect the [`Dockerfile`](../src/images/sqlserver/admin_client/Dockerfile) in the `src/images/sqlserver/admin_client` directory to see the commands that are required to configure the Admin client.

Use the following format to run toolkit tasks by using the Admin Client:
```
docker exec -u i2analyze -t admin_client /opt/IBM/i2analyze/toolkit/scripts/setup -t <toolkit task>
```

#### Solr collection
Before the Solr collection can be created, all of the Solr nodes that the collection comprises must be running. In the Docker environment, ensure that both of the Solr containers are running.

You can create the Solr collection from the Admin client, or you can run the command from one of the Solr servers.

To create the Solr collection by using the Admin client, run the following command:
```
docker exec -u i2analyze -t admin_client /opt/IBM/i2analyze/toolkit/scripts/setup -t createSolrCollections --hostname admin_client
```
The Solr collection is created.

To test the Solr Collection, click **Cloud** in the Solr Web UI, or you can go to [http://localhost:8983/solr/#/~cloud](http://localhost:8983/solr/#/~cloud). The user name is `solradmin` and the password is the Solr password set in the `credentials.properties` file.
A horizontal tree with the collection as the root is displayed. Here you can see the breakdown of the shards, nodes, and replicas on the collection.

#### Create the Information Store database
Create the Information Store database in the SQL Server instance on the SQL Server container.

To create the Information Store database by using the Admin client, run the following command:
```
docker exec -u i2analyze -t admin_client /opt/IBM/i2analyze/toolkit/scripts/setup -t createDatabases
```
To check that the database is created correctly, connect to the database. For example, connect by using SQL Server Management Studio. The user name is `i2analyze` and the password is the database password set in the `credentials.properties` file.
>If you are using Windows 7, you must forward port `1433` from your Virtual Box virtual machine.)

### Liberty container
The Liberty application server hosts the i2 Analyze application, and provides all of the REST services that the client uses. In this deployment, Liberty is deployed on its own server. Your configured i2 Analyze toolkit, and the SQL Server client tools must be installed on the Liberty server.

To build the `liberty` image, run the following command from the `src/images/sqlserver` folder:
```
docker build -t liberty_sqlserver_image liberty
```
The Liberty image is created with the name `liberty_sqlserver_image`.

Run the Liberty container:
```
docker run -d --name liberty -p 9082:9082 -p 9445:9445 --net eianet -u i2analyze liberty_sqlserver_image
```
The i2 Analyze application is installed on the Liberty server. Inspect the [`Dockerfile`](../src/images/sqlserver/liberty/Dockerfile) in the `src/images/sqlserver/liberty` directory to see the commands that are run to create the Liberty server in a non-Docker environment.

The Liberty server is configured, and the `opal-server` is started.

---

## Results
After you complete the previous instructions, i2 Analyze is deployed across five Docker containers. By inspecting the Dockerfiles and the toolkit tasks that are used in the previous commands, you can identify the steps that are required to replicate the distributed deployment in a non-Docker environment.

---

## Test the deployment
To test the deployment, connect to i2 Analyze from Analyst's Notebook Premium. The URL that you use to connect is: [http://i2demo:9082/opal](http://i2demo:9082/opal).

Log in using the user name `Jenny` with the password `Jenny`.

You can use the **Upload records** function to add data to the Information Store, and then search for that data.
