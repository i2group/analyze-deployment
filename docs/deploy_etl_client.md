# Ingesting data remotely
i2 Analyze supports physical architectures in which the database is hosted on the same server as the application, or on a different one. You can also choose to locate your Extract Transform Load (ETL) logic on the same server as the i2 Analyze application, or on the same server as the database, or on an entirely separate server.
The distributed deployment example shows you how to set up the ETL logic on a separate server.

For more information about the ingestion architecture and the ETL toolkit, see [Understanding the architecture](https://www.ibm.com/support/knowledgecenter/SSXVTH_latest/com.ibm.i2.iap.admin.ingestion.doc/architecture_and_ingestion.html).

## Before you begin
Ensure that you can connect to the deployment and submit data by using Analyst's Notebook Premium.

## Deploying the ETL toolkit
In the distributed deployment example, the ETL toolkit is deployed in its own server. Your configured i2 Analyze toolkit and database client must be installed on the ETL toolkit server.

The `createEtlToolkit` toolkit task creates the ETL toolkit. In the Docker environment, the ETL toolkit is created inside the `admin_client` container and then copied into the ETL client container.

In the Docker environment, the `etl_client_sqlserver_image` is created when you run the `buildImages` script. The ETL client container is started when you run the `runContainers` script. If you cleaned your environment, rebuild and rerun the container.
To build the ETL client image, run the following command from the `src/images` folder:  
For SQL Server:
```
docker build -t etl_client_sqlserver_image sqlserver/etl_client
```

For Db2:
```
docker build -t etl_client_db2_image db2/etl_client
```


To run the ETL client container, run the following command:  
For SQL Server:
```
docker run -d --name etl_client --net eianet -u i2analyze etl_client_sqlserver_image
```
For Db2:
```
docker run -d --name etl_client --net eianet -u i2analyze etl_client_db2_image
```

Run the `deployEtlClient` script from the `src/scripts` directory to create a new ETL toolkit and copy it to the `etl_client` container:
```
./deployEtlClient
```

For more information about deploying the ETL toolkit in a non-Docker environment, see [Deploying the ETL toolkit](https://www.ibm.com/support/knowledgecenter/SSXVTH_latest/com.ibm.i2.iap.admin.ingestion.doc/deploying_the_etl_toolkit.html).

## Configuring the ETL toolkit for Db2
The `etl_client` container includes the `initializeEtlClient` script that you must run in the Docker environment when you are using Db2.

The `initializeEtlClient` script catalogs the remote Db2 node and database with the Db2 Client that is installed on the ETL client. To complete this process in a non-Docker environment, see [Deploying the ETL toolkit](https://www.ibm.com/support/knowledgecenter/SSXVTH_latest/com.ibm.i2.iap.admin.ingestion.doc/deploying_the_etl_toolkit.html).

Run the `initializeEtlClient` script on the `etl_client` container:
```
docker exec -u i2analyze -t etl_client /opt/IBM/i2analyze/initializeEtlClient
```
You can inspect the [`initializeEtlClient`](../src/images/db2/etl_client/initializeEtlClient) script in the `src/images/db2/etl_client` directory.
>If the connection to Db2 uses SSL, run the following command:  
`docker exec -u i2analyze -t etl_client /opt/IBM/i2analyze/initializeEtlClient enable`.

## Ingesting the example data
The ETL client container includes the `ingestExampleData` script that you can run in the Docker environment to ingest example data into the Information Store.
You can now use the ETL toolkit on the ETL client server to ingest data into the Information Store.

The `ingestExampleData` script in the Docker container ingests example data into the Information Store. To complete this process in a non-Docker environment, see [Running ingestion commands](https://www.ibm.com/support/knowledgecenter/SSXVTH_latest/com.ibm.i2.iap.admin.ingestion.doc/running_ingestion_commands.html).

Run the `ingestExampleData` script on the `etl_client`. Type the password that you set in the `credentials.properties` file for Information Store database:
```
docker exec -u i2analyze -it etl_client /opt/IBM/i2analyze/ingestExampleData
```
An `E_Person` entity staging table is created and populated, and the data that it contains is ingested. An `L_Associate` link staging table is created and populated, and the data that it contains is ingested.

You can inspect the [`ingestExampleData`](../src/images/sqlserver/etl_client/ingestExampleData) script in the `etl_client` directory.

## Testing the deployment
To test that the data ingested successfully, connect to the Information Store in Analyst's Notebook Premium and search for `Jo Black` and complete an expand operation. You should see a link to another entity named `John Smith`.
