# Upgrading a distributed deployment to version 4.3.2 of i2 Analyze
To upgrade the example distributed deployment, you must run an upgrade command on each server in your deployment. The following instructions detail what is required on each container, and how to use these steps to upgrade i2 Analyze on physical servers.

## Before you begin
- You must have a working distributed deployment of a previous version of i2 Analyze, completed with a previous version of the distributed deployment example at version V.2.2.0. 

>Important: If you are upgrading a distributed deployment that was created by using V1.x of the distributed deployment example, you must not update your distributed deployment example source code. Continue to use the same scripts, images, and containers from V1.x of the distributed deployment example.
In addition, you must run any commands on the Docker container as the `root` user instead of the `i2analyze` user. For example, `docker exec -u root liberty /opt/IBM/i2analyze/toolkit/scripts/setup -t stopLiberty` instead of `docker exec -u i2analyze liberty /opt/IBM/i2analyze/toolkit/scripts/setup -t stopLiberty`.

---
## Prerequisites for upgrading the distributed deployment
Download, install, and configure the prerequisites for upgrading a distributed deployment.

### Example code
Clone or download the distributed deployment example from <https://github.com/IBM-i2/Analyze-Deployment/releases>.

Remove the current distributed example code, but ensure the containers stay running.

Extract the distributed Example that you just downloaded.

### i2 Analyze
Download i2 Analyze for Linux. You download the `IBM_i2_Analyze_4.3.2_Linux_Archive.tar.gz` version 4.3.2 using the following part number: *CC72BML*.

Rename the `tar.gz` file to `i2analyze.tar.gz`.

Copy the archive file to the `src/images/common/ubuntu_toolkit/i2analyze` directory.

### Analyst's Notebook Premium
Download *i2 Analyst's Notebook Premium* version 9.2.2 using the following part number: *CC6ZPML*.

Upgrade Analyst's Notebook Premium. For more information, see [Upgrading IBM i2 Analyst's Notebook Premium](https://www.ibm.com/support/knowledgecenter/SSXVXZ/com.ibm.i2.iap.upgrade.doc/upgrading_anbp.html).

---
## Preparing i2 Analyze
Back up and install i2 Analyze before you upgrade i2 Analyze.

### Stopping Liberty
Before you upgrade your deployment, you must stop the application server.

To stop Liberty, run the following command on the `liberty` container:
```
docker exec -u i2analyze liberty /opt/IBM/i2analyze/toolkit/scripts/setup -t stopLiberty
```
The console output from the `stopLiberty` task is output directly to the console.

### Backing up the configuration
Before you upgrade your deployment, you must backup your current configuration. In the distributed deployment example, the `backupConfiguration` script creates a copy of your configuration directory on the `admin_client` container. The backup of your configuration is in the `src/configuration_mods/configuration_backup` directory.

In a non-Docker environment, ensure that you have a copy of the `configuration` directory that contains your complete configuration in a location outside of the i2 Analyze toolkit. The process of upgrading i2 Analyze removes the deployment toolkit from each server in the deployment. Ensure that the backup of your configuration is up-to-date for each server in your deployment.

### Installing i2 Analyze
You must install version 4.3.2 of i2 Analyze on each server in the deployment. In the distributed deployment example, you can use the `installToolkit` script to install i2 Analyze on each container.

To install i2 Analyze on each container, run the following command from the `src/scripts` directory:
```
./installToolkit ./images/common/ubuntu_toolkit/i2analyze/i2analyze.tar.gz
```

In a non-Docker environment, install i2 Analyze on each server by using the following instructions: [Upgrading i2 Analyze](https://www.ibm.com/support/knowledgecenter/SSXVXZ/com.ibm.i2.iap.upgrade.doc/upgrading_4_1_3.html).

### Copying the backed up configuration
In the distributed deployment example, you upgrade the configuration on the `admin_client` container. You must copy the backed up configuration of the deployment toolkit to the Admin Client.

To copy your backed up configuration to the `admin_client` container, run the following command from the `src` directory:
```
docker cp ./configuration_mods/configuration_backup admin_client:/opt/IBM/i2analyze/toolkit/configuration
```
When the directory is copied, the owner of the directory, and all files within it, is changed. The user that runs the deployment script must be able to write to files within the `configuration` directory. To change the ownership of the directory and the files, run the following command:
```
docker exec -u root admin_client chown -R i2analyze:i2analyze /opt/IBM/i2analyze/toolkit/configuration
```
The configuration is now on the `admin_client` container.

In a non-Docker environment, copy your backed up configuration directory to the `i2analyze/toolkit/configuration` directory on your equivalent of the Admin Client server.

---
You can complete a quick upgrade or you can upgrade manually. Completing the upgrade manually requires you to run each of the steps completed automatically in the quick upgrade. By upgrading manually, you can see in detail what is required on each container and how to use this to upgrade a deployment on physical servers.

## Quick upgrade
To upgrade the example distributed deployment, a script is provided that upgrades i2 Analyze and its components.

To upgrade your deployment, run the `./upgradeDeployment` script from the `src/scripts` directory.

All of the components of i2 Analyze are upgraded and the application is started. You can test the deployment by completing the steps in *Testing the deployment*.

---

## Upgrade the deployment manually
## Upgrading and copying the configuration
Upgrade the i2 Analyze configuration to version 4.3.2. To upgrade the configuration, run the following command on the `admin_client` container:
```
docker exec -u i2analyze -t admin_client /opt/IBM/i2analyze/toolkit/scripts/setup -t upgradeConfiguration
```

The console output from the `upgradeConfiguration` task is output directly to the console.

The upgraded configuration must be copied to each of the servers in the deployment. In a Docker environment, first you must copy the upgraded configuration to your local machine by running the following command inside the `src/scripts` directory:  
For SQL Server:
```
docker cp admin_client:/opt/IBM/i2analyze/toolkit/configuration ../configuration_mods/sqlserver/configuration_upgraded
```
For Db2:
```
docker cp admin_client:/opt/IBM/i2analyze/toolkit/configuration ../configuration_mods/db2/configuration_upgraded
```
Then, copy the upgraded configuration to each server. In the distributed deployment example, you can run the `updateServerConfigurations` script to copy the configuration to each container:
```
./updateServerConfigurations configuration_upgraded
```

In a non-Docker environment, copy the upgraded configuration to the `i2analyze/toolkit/configuration` directory on each server.

## Upgrading and starting the components of i2 Analyze
After the upgraded configuration is present on each server, you must upgrade each component of the deployment to version 4.3.2.

You must upgrade and start the components of a deployment in the order that they are described here.

### Upgrading ZooKeeper
To upgrade ZooKeeper, run the following command on the `zookeeper`, `zookeeper2` and `zookeeper3` containers:
```
docker exec -u i2analyze zookeeper /opt/IBM/i2analyze/toolkit/scripts/setup -t upgradeZookeeper --hostname zookeeper.eianet
docker exec -u i2analyze zookeeper2 /opt/IBM/i2analyze/toolkit/scripts/setup -t upgradeZookeeper --hostname zookeeper2.eianet
docker exec -u i2analyze zookeeper3 /opt/IBM/i2analyze/toolkit/scripts/setup -t upgradeZookeeper --hostname zookeeper3.eianet
```
The console output from the `upgradeZookeeper` task is output directly to the console.

### Upgrading Solr
To upgrade Solr, run the following command on the `solr` and `solr2` containers:
```
docker exec -u i2analyze solr /opt/IBM/i2analyze/toolkit/scripts/setup -t upgradeSolr --hostname solr.eianet
docker exec -u i2analyze solr2 /opt/IBM/i2analyze/toolkit/scripts/setup -t upgradeSolr --hostname solr2.eianet
```
The console output from the `upgradeSolr` task is output directly to the console.

### Upgrading the Information Store database
To upgrade the Information Store database, run the following command on the `admin_client` container:
```
docker exec -u i2analyze admin_client /opt/IBM/i2analyze/toolkit/scripts/setup -t upgradeDatabases --hostname admin_client.eianet
```
The console output from the `upgradeDatabases` task is output directly to the console.

### Starting ZooKeeper
To start ZooKeeper, run the following commands on the `zookeeper`, `zookeeper2` and `zookeeper3` containers:
```
docker exec -u i2analyze zookeeper /opt/IBM/i2analyze/toolkit/scripts/setup -t startZkHosts --hostname zookeeper.eianet
docker exec -u i2analyze zookeeper2 /opt/IBM/i2analyze/toolkit/scripts/setup -t startZkHosts --hostname zookeeper2.eianet
docker exec -u i2analyze zookeeper3 /opt/IBM/i2analyze/toolkit/scripts/setup -t startZkHosts --hostname zookeeper3.eianet
```
The console output from the `startZkHosts` task is output directly to the console.

### Upload the Solr configuration on ZooKeeper
To upload the Solr configuration by using the Admin client, run the following command:
```
docker exec -u i2analyze -t admin_client /opt/IBM/i2analyze/toolkit/scripts/setup -t createAndUploadSolrConfig --hostname admin_client.eianet
```
The Solr configuration is uploaded.

### Starting Solr
To start Solr, run the following commands on the `solr` and `solr2` containers:
```
docker exec -u i2analyze solr /opt/IBM/i2analyze/toolkit/scripts/setup -t startSolr --hostname solr.eianet
docker exec -u i2analyze solr2 /opt/IBM/i2analyze/toolkit/scripts/setup -t startSolr --hostname solr2.eianet
```
The console output from the `startSolr` tasks are displayed directly to the console.

### Upgrading the Solr collection
To upgrade the Solr collection, run the following command on the `admin_client` container:
```
docker exec -u i2analyze -t admin_client /opt/IBM/i2analyze/toolkit/scripts/setup -t upgradeSolrCollections --hostname admin_client.eianet
```
The console output from the `upgradeSolrCollections` task is output directly to the console.

### Upgrading Liberty
To upgrade Liberty and the i2 Analyze application, run the following command on the `liberty` container:
```
docker exec -u i2analyze -t liberty /opt/IBM/i2analyze/toolkit/scripts/setup -t upgradeLiberty
```
The console output from the `upgradeLiberty` task is output directly to the console.

### Starting Liberty
Start Liberty with the upgraded i2 Analyze application.

To start Liberty, run the following command on the `liberty` container:
```
docker exec -u i2analyze liberty /opt/IBM/i2analyze/toolkit/scripts/setup -t startLiberty
```
The console output from the `startLiberty` task is output directly to the console.


### (Optional) Upgrading the ETL Client
If your deployment uses an ETL Client, you must recreate it with the new upgraded toolkit.

In the distributed deployment example, the `deployEtlClient` script removes the old installation from your running etl_client container, creates a new etl_client in the admin_client container and copies it over to the `etl_client` container creates a copy of your configuration directory on the Admin Client container. The backup of your configuration is in the `src/configuration_mods/configuration_backup` directory.

---

## Results
All of the components of i2 Analyze are upgraded and the application is started.

---

## Testing the deployment
To test the deployment upgraded successfully, connect to i2 Analyze from Analyst's Notebook Premium. The URL that you use to connect is the same as you used to before you run the upgrade process.

Log in using the user name `Jenny` with the password `Jenny`.

You can use the **Upload records** functionality to add data to the Information Store, and then search for that data or data that already existed.
