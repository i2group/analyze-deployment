# Deploying the distributed deployment example manually
The manual deployment of the distributed deployment example requires you to run each of the steps that were completed automatically in the Quick deploy. The following instructions detail what is required on each container, and how to translate this to deploying i2 Analyze on a physical server.

>**Important**: The distributed example uses a Docker environment to demonstrate a distributed deployment of i2 Analyze. The Docker environment is not designed to be used on customer sites for test or production systems. After you understand how the distributed deployment is deployed, replicate the deployment on physical servers.

## Before you begin
- Complete the [Quick deploy](deploy_quick_start.md) section at least once before you start the manual deployment. The software prerequisites that you download for the Quick deploy are also used in this section.
- Complete the [Clean your environment](deploy_clean_environment.md) section to ensure that none of the images, containers, or network already exist.

You must run all Docker commands from a command line that has Docker initialized.

>For Windows 7, you must also forward the required ports from your local machine to the virtual machine that hosts Docker.
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
The i2 Analyze configuration is required by all servers that host components of i2 Analyze, with the exception of the database server. In the `src/scripts` directory of the distributed deployment example, the `copyConfiguration` script copies the i2 Analyze configuration from the `src/configuration` directory to the `src/images/<container_name>/configuration` directory for each container.

From the `src/scripts` directory, run the `copyConfiguration` script file.

### Results
In a non-Docker environment, copying the configuration translates to following steps:  
Downloading and extracting the i2 Analyze toolkit onto a server.

Copying the `examples/configurations/information-store-opal/configuration` directory into the `toolkit` directory of your extracted i2 Analyze toolkit.

You must populate the configuration for your environment, use the `src/configuration` directory as a reference. This is the centralized i2 Analyze toolkit and configuration that you copy to your servers.

---

## Build the prerequisite images
In the distributed deployment example, some of the images are built on top of other images. The prerequisite images must be built first, as described in the following section.

### Ubuntu toolkit image
The `ubuntu_toolkit_image` is an image that contains the Ubuntu operating system with i2 Analyze installed and contains the i2 Analyze configuration.

When you build the `ubuntu_toolkit_image`, the `i2analyze.tar.gz` that you copied into the `src/images/ubuntu_toolkit/i2analyze` directory as part of the Quick deploy is copied and extracted into the image.

To build the ubuntu toolkit image, run the following from the `src/images` folder:
```
docker build -t ubuntu_toolkit_image ubuntu_toolkit
```
The Ubuntu toolkit image is created with the name `ubuntu_toolkit_image`.

### DB2 installer image
The DB2 installation files must be added to the `db2_installer_image`.

To build the `db2_installer` image, run the following from the `src/images` folder:
```
docker build -t db2_installer_image db2_installer
```
The `db2_installer` image is created with the name `db2_installer_image`. The prerequisite packages and DB2 installer files are installed.

### Base client image
The `base_client` represents a system that has the configured i2 Analyze toolkit and DB2 Client. This is used by any container that must communicate with DB2.

To build the `base_client_image` image, run the following from the `src/images` folder:
```
docker build -t base_client_image base_client
```

---

## Configuring and running the containers
Each Docker container requires a Docker image. In a non-Docker environment, this is equivalent to configuring and starting a physical server that is used to host a component of i2 Analyze.

### DB2 container
In i2 Analyze, the Information Store is a DB2 database. To make it easier to demonstrate, the installation of DB2 is automated. In this deployment, DB2 is installed on its own server.

To build the `db2` image, run the following from the `src/images` folder:
```
docker build -t db2_image db2
```
The DB2 image is created with the name `db2_image`.

Run the db2 container:
```
 docker run -d --privileged --name db2 -p 50000:50000 -p 50001:50001 --net eianet -u db2inst1 db2_image
```
>Note: Ports 50000 and 50001 are exposed so that the database can be accessed from outside of the `eianet` network. In a production environment this is not necessary, because clients only access Liberty.

Check that the container started correctly by using the docker logs:
```
docker logs -f db2
```
>Note: To exit the log display, use `Ctrl + C`.

Inspect the `Dockerfile` in the `src/images/db2` directory to see the commands that are required to install DB2 on a server in a non-Docker environment.

DB2 is installed using a response file, and an instance of DB2 is created with the required DB2 users.

### ZooKeeper container
ZooKeeper is the service that is used to maintain configuration information and distributed synchronization across Solr. In this deployment, ZooKeeper is deployed on its own server. On the ZooKeeper server, you must have your configured i2 Analyze toolkit installed.

To build the `zookeeper` image, run the following from the `src/images` folder:
```
docker build -t zookeeper_image zookeeper
```
Run the ZooKeeper container:
```
docker run -d --name zookeeper --net eianet -u root zookeeper_image
```
Then, check that ZooKeeper started correctly by using the docker logs:
```
docker logs -f zookeeper
```
Inspect the `Dockerfile` in the `src/images/zookeeper` directory to see the commands that are required to configure a ZooKeeper server in a non-Docker environment.

The ZooKeeper container is started. The container starts and configures ZooKeeper, and hosts the ZooKeeper server. The `topology.xml` file in the i2 Analyze configuration defines the values for the ZooKeeper server.

### Solr containers
Solr is used to manage the search index in a deployment of i2 Analyze. In this deployment, Solr is distributed across 2 servers. On each Solr server, you must have your configured i2 Analyze toolkit installed.

To build the Solr images, run the following from the `src/images` folder:
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

Inspect the `Dockerfiles` in the `src/images/solr` and `src/images/solr2` directories to see the commands that are required to configure a Solr server in a non-Docker environment.

The images include an i2 Analyze `topology.xml` file that defines the values for the configuration of Solr. When the server starts, the appropriate Solr nodes are started.

When you start the Solr container, the port that Solr runs on in the container is specified, in this example it is either `8983` or `8984`. The specified port is mapped on the host machine, so that you can access Solr and the Solr web UI from the host machine.

After the Solr nodes are running, you can use the Solr Web UI to inspect the Solr and ZooKeeper configurations. Connect to the Solr Web UI on the `solr` container. In a web browser, go to the following URL to connect to the Solr Web UI: [http://localhost:8983/solr/#](http://localhost:8983/solr/#). The username is `solradmin` and the password is the solr password set in the `credentials.properties` file.  
>Where the port number is the same as the one that is mapped to local machine when the Solr container is run.
>The URL uses `localhost` because the `8983` port is mapped from the host machine to the docker container. In a non-Docker environment, connect using the host name of the Solr server.

### Admin client container
In this deployment, the Admin client is a separate server that is designed for running toolkit tasks in a distributed environment. Your configured i2 Analyze toolkit, and a DB2 client must be installed on the the server that you want to use to interact with Liberty and DB2.

To build the Admin client image, run the following from the `src/images` folder:
```
docker build -t admin_client_image admin_client
```
The Admin client image is created with the name `admin_client_image`.

Run the Admin client container:
```
docker run -d --name admin_client --net eianet -u i2analyze admin_client_image
```
Inspect the `Dockerfile` in the `src/images/admin_client` directory to see the commands that are required to configure the Admin client.

Use the following format to run toolkit tasks using the Admin Client:
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

To test the Solr Collection, click **Cloud** in the Solr Web UI, or you can go to [http://localhost:8983/solr/#/~cloud](http://localhost:8983/solr/#/~cloud). The username is `solradmin` and the password is the solr password set in the `credentials.properties` file.
A horizontal tree with the collection as the root is displayed. Here you can see the breakdown of the shards, nodes, and replicas on the collection.

#### Create the Information Store database
Create the Information Store database in the DB2 instance on the DB2 container.

To create the Information Store database by using the Admin client, run the following command:
```
docker exec -u i2analyze -t admin_client /opt/IBM/i2analyze/toolkit/scripts/setup -t createDatabases
```
To check that the database is created correctly, connect to the database. For example, connect using IBM Data Studio. The user name is `i2analyze` and the password is the database password set in the `credentials.properties` file.
>If you are using Windows 7, you must forward port `50000` from your Virtual Box virtual machine.)

### Liberty container
The Liberty application server hosts the i2 Analyze application, and provides all of the REST services that the client uses. In this deployment, Liberty is deployed on its own server. Your configured i2 Analyze toolkit, and a DB2 client must be installed on the Liberty server.

To build the liberty image, run the following from the `src/images` folder:
```
docker build -t liberty_image liberty
```
The Liberty image is created with the name `liberty_image`.

Run the Liberty container:
```
docker run -d --name liberty -p 9082:9082 -p 9445:9445 --net eianet -u i2analyze liberty_image
```
The i2 Analyze application is installed on the Liberty server. Inspect the `Dockerfile` in the `src/images/liberty` directory to see the commands that are run to create the Liberty server in a non-Docker environment.

The Liberty server is configured, and the `opal-server` is started.

The remote Information Store database must be cataloged to enable to run DB2 operations remotely on the database from the Liberty server.
To catalog the database, run the following command:
```
docker exec -u i2analyze -t liberty /opt/IBM/i2analyze/toolkit/scripts/setup -t catalogDB2Databases
```
Your remote database is now cataloged on the Liberty server.

---

## Results
After you have completed the previous instructions, you have an i2 Analyze deployment distributed across 5 Docker containers. By inspecting the Dockerfiles and the toolkit tasks used in the above commands, you can identify the steps required to replicate the distributed deployment in a non-Docker environment.

---

## Test the deployment
To test the deployment, connect to i2 Analyze from Analyst's Notebook Premium. The URL that you use to connect is: [http://i2demo:9082/opal](http://i2demo:9082/opal).

Log in using the user name `Jenny` with the password `Jenny`.

You can use the **Upload records** functionality to add data to the Information Store, and then search for that data.
