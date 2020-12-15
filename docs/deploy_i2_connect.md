# Deploying i2 Analyze with i2 Connect
IBM i2 Connect enables analysts to search for and retrieve data from external data sources by using the Opal quick search functionality, and then analyse the results on a chart in Analyst's Notebook Premium.

You can deploy i2 Analyze with support for i2 Connect only, or with the Information Store and i2 Connect.

For more information about deploying i2 Analyze with i2 Connect, see [IBM i2 Analyze and i2 Connect](https://www.ibm.com/support/knowledgecenter/SSXVTH_latest/com.ibm.i2.connect.developer.doc/i2_connect_overview.html).

## Before you begin
- You must complete the [Quick deploy](deploy_quick_start.md) or deploy the example manually, and your deployment must be running.
- If you deployed the example with one of the configurations in the `configuration_mods` directory or changed the `topology.xml` file. Reset your example deployment to the base configuration before you deploy i2 Analyze with i2 Connect. To reset your environment, run the following command from the `src/scripts` directory:
```
./resetEnvironment
```
---

## Creating the keystores and certificates
Run the `createKeysAndStores` script to create the stores, certificates, and certificate authority. For example, run the following command from the `src/scripts` directory:
```
./createKeysAndStores
```
You are prompted to enter a password that is used for each of the keystores and truststores that are created. The password that you specify here is used later.

For more information about the stores and certificates that are created, see [Keystores and certificates for components of i2 Analyze](./securing_certificates.md).

## Configuring connector
You must specify the passphrase for the key that the connector uses. Specify the `keyPassphrase` in the `src/images/common/connector/security-config.json` file. The passphrase that you specify must match the value that you entered for i2 Connect connector key store and certificate signing request when you ran the `createKeysAndStores` script.

For more information about securing the example connector, see [Securing the example connector](https://www.ibm.com/support/knowledgecenter/SSXVTH_latest/com.ibm.i2.eia.go.live.doc/t_connect_example_security.html).

### Specifying the credentials
You must specify the credentials for your deployment in the `src/configuration/environment/credentials.properties`. Set the passwords to use for each of the keystore and truststore credentials. The passwords must match the values that you entered for the corresponding keystores and truststores when you ran the `createKeysAndStores` script.

For more information about the credentials file, see [Modifying the credentials](https://www.ibm.com/support/knowledgecenter/SSXVTH_latest/com.ibm.i2.eia.go.live.doc/t_specifying_credentials.html).

## Deploying the example connector
In the distributed deployment example, the example connector is deployed in its own server.

In the Docker environment, the `connector_image` is created when you run the `buildImages` script. The example connector container is started when you run the `runContainers` script. If you ran the `clean` script, rebuild and rerun the container.
To build the connector image, run the following command from the `src/images` folder:
```
docker build -t connector_image common/connector
```

The connector image is created with the name `connector_image`.

To run the `connector` container, run the following command:
```
docker run -d --name connector --net eianet -u i2analyze connector_image
```
---

You can complete a quick i2 Connect deployment or you can complete the i2 Connect setup manually. Completing the i2 Connect deployment manually requires you to run each of the steps that were completed automatically in the quick i2 Connect deployment so that you can replicate the steps in a non-Docker environment.

## Quick deploy
To set up the example connector in the distributed deployment example, a script is provided that deploys i2 Analyze with i2 Connect and the example connector. You can decide whether to deploy i2 Analyze with i2 Connect only, or with the Information Store and i2 Connect.  
To deploy with i2 Connect only, you must specify the `i2connect` configuration modification when you run the `deployDaod` script.  
To deploy with the Information Store and i2 Connect, you must specify the `i2connect_istore` configuration modification when you run the `deployDaod` script.

Run the `deployDaod` script from the `src/scripts` directory to set up the i2 Analyze deployment with i2 Connect only and start the connector with the correct configuration.
```
./deployDaod i2connect
```

For more information about deploying a connector for i2 Connect in a non-Docker environment, see [Creating a connector for i2 Connect](https://www.ibm.com/support/knowledgecenter/SSXVTH_latest/com.ibm.i2.connect.developer.doc/creating_a_connector.html).

---
## Deploy example connector manually

## Stopping Liberty
Run the `stopLiberty` task on the `liberty` container:
```
docker exec -u i2analyze liberty /opt/IBM/i2analyze/toolkit/scripts/setup -t stopLiberty
```

## Configuring i2 Analyze
Configure i2 Analyze to use i2 Connect. In the distributed deployment example, you can see the configuration modifications in the `src/configuration_mods/<database management system>/i2connect` directory.

The `updateServerConfigurations` script copies a configuration to each of the example containers. To copy the i2 Connect only configuration, run the following command:
```
./updateServerConfigurations i2connect
```
If you want to deploy i2 Analyze with the Information Store and i2 Connect, run `updateServerConfigurations i2connect_istore`.

## Deploying i2 Analyze
Run the `deployLiberty` task on the `liberty` container:
```
docker exec -u i2analyze liberty /opt/IBM/i2analyze/toolkit/scripts/setup -t deployLiberty
```

## Creating the Solr configuration on ZooKeeper
You can create and upload the Solr configuration from the Admin client, or you can run the command from one of the ZooKeeper servers.

To create the Solr configuration by using the Admin client, run the following command:
```
docker exec -u i2analyze -t admin_client /opt/IBM/i2analyze/toolkit/scripts/setup -t createAndUploadSolrConfig --hostname admin_client.eianet
```
The Solr configuration is created and uploaded.

## Creating the Solr Collection
Create the Solr Collection that is used by a deployment with i2 Connect, run the `createSolrCollections` task on the `admin_client` container.
```
docker exec -t -u i2analyze admin_client /opt/IBM/i2analyze/toolkit/scripts/setup -t createSolrCollections --hostname admin_client.eianet
```

## Copying configuration to example connector
To update the `connector` container with the updated `security-config.json` file, run the following commands from the `src` directory:
```
docker cp images/common/connector/security-config.json connector:/opt/IBM/i2analyze/example_connector/security-config.json
docker restart connector
```

## Starting Liberty
To start Liberty, run the following command on the `liberty` container:
```
docker exec -u i2analyze liberty /opt/IBM/i2analyze/toolkit/scripts/setup -t startLiberty
```
The console output from the `startLiberty` task is output directly to the console.

---

## Results
All the setup is completed and the application is started.

---

## Testing the deployment
To test the deployment was configured successfully, connect to i2 Analyze from Analyst's Notebook Premium.

If you deployed i2 Analyze with i2 Connect only, the URL that you use to connect is: `http://i2demo:9082/opaldaod`.

If you deployed i2 Analyze with the Information Store and i2 Connect, the URL that you use to connect is: `http://i2demo:9082/opal`.

Log in using the user name `Jenny` with the password `Jenny`.

You can use the **Search Stores** functionality to search for data and query the external source.
