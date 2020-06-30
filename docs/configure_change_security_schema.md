# Updating the Security Schema
An i2 Analyze security schema defines the security dimension values that you can assign to items and records in the Information Store, and the security permissions that you assign to groups of users. Modify the security schema in the i2 Analyze configuration, then update the Information Store database to conform to the new security schema, then restart the application server.

For more information about the i2 Analyze security schema, see [Configuring the security schema](https://www.ibm.com/support/knowledgecenter/SSXVXZ/om.ibm.i2.eia.go.live.doc/modifying_security_schema.html).

## Before you begin
- Ensure that you can connect to the deployment with the current security schema, and submit data by using Analyst's Notebook Premium.
- Ensure that all of the Docker containers are running.

## Modifying the security schema file
In the distributed deployment example, the `example-dynamic-security-schema.xml` file that represents the i2 Analyze security schema is in the following directory: `src/configuration/fragments/common/WEB-INF/classes`.

In an XML editor, open the `example-dynamic-security-schema.xml` file from the `classes` directory. Modify the security schema. For more information about the changes that you can make to the security schema file, see [Modifying the security schema](https://www.ibm.com/support/knowledgecenter/SSXVXZ/om.ibm.i2.eia.go.live.doc/modifying_security_schema.html).

After you modify the file, save your changes.

## Copying the configuration
In the distributed deployment example, the security schema changes are completed on the Admin client and Liberty containers. To update the deployment with the changes to the security schema, you must run toolkit tasks that interact with the Information Store database and the i2 Analyze application.

The changed configuration must be copied to the `admin_client` and `liberty` containers.

To copy, and overwrite, your configuration to the `admin_client` and `liberty` containers, run the following commands from the `src` directory:
```
docker cp ./configuration/fragments/common/WEB-INF/classes admin_client:/opt/IBM/i2analyze/toolkit/configuration/fragments/common/WEB-INF/
docker cp ./configuration/fragments/common/WEB-INF/classes liberty:/opt/IBM/i2analyze/toolkit/configuration/fragments/common/WEB-INF/
```
The new configuration is now on the `admin_client` and `liberty` containers.

When the directory is copied, the owner of the directory, and all files within it, is changed. The user that runs the deployment script must be able to write to files within the `configuration` directory. To change the ownership of the directory and the files, run the following commands:
```
docker exec -u root admin_client chown -R i2analyze:i2analyze /opt/IBM/i2analyze/toolkit/configuration
docker exec -u root liberty chown -R i2analyze:i2analyze /opt/IBM/i2analyze/toolkit/configuration
```

In a non-Docker environment, copy the `example-dynamic-security-schema.xml` file and any other modified files to the same location on the Liberty server and ensure that the correct permissions are set.

## Stopping Liberty
Before you update the security schema, you must stop the application server.

You can shut down the application by using the `stopLiberty` i2 Analyze toolkit task. In the distributed deployment example, run the following command in the `liberty` Docker container:
```
docker exec -u i2analyze liberty /opt/IBM/i2analyze/toolkit/scripts/setup -t stopLiberty
```
The console output from the `stopLiberty` task is output directly to the console.

## Clear the search index
Some modifications to the security schema require you to clear the search index. For more information about the changes that require a reindex, see [Modifying security dimensions](https://www.ibm.com/support/knowledgecenter/SSXVXZ/com.ibm.i2.eia.go.live.doc/security_schema_modify.html) and [Modifying security permissions](https://www.ibm.com/support/knowledgecenter/SSXVXZ/com.ibm.i2.eia.go.live.doc/t_modify_dynamic.html).

If your changes require you to clear the search index, complete the rest of this section.

To clear the search index, you can run the command from Admin client or Liberty server. In the distributed deployment example, the `admin_client` container is used to run the command. The `admin_client` container includes the i2 Analyze toolkit and a DB2 client installation. When you run the container, the remote Information Store database is cataloged. You can run commands that modify the database from this container.

To clear the search index, run the following command:
```
docker exec -u i2analyze -it admin_client /opt/IBM/i2analyze/toolkit/scripts/setup -t clearSearchIndex --all --hostname admin_client.eianet
```

The search index is cleared, however any data that was in the database remains in the database.

## Updating the database
Update the database to conform to the updated security schema.

To update the database, you can run the command from the Liberty or Admin client server. In this distributed deployment example, the `admin_client` container is used to run the commands. The `admin_client` container includes the i2 Analyze toolkit and a DB2 client installation. When you run the container, the remote Information Store database is cataloged. You can run the commands that modify the database from this container.

To update the database for the updated security schema, run the following command:
```
docker exec -u i2analyze -t admin_client /opt/IBM/i2analyze/toolkit/scripts/setup -t updateInformationStoreSecuritySchema
```

## Updating the application
If you cleared the search index, you must also update the application.

Run the following commands on the Liberty server to deploy Liberty:

```
docker exec -u i2analyze liberty /opt/IBM/i2analyze/toolkit/scripts/setup -t deployLiberty
```

## Starting Liberty
Start Liberty to load the updated security schema.

Run the following command to start Liberty:
```
docker exec -u i2analyze liberty /opt/IBM/i2analyze/toolkit/scripts/setup -t startLiberty
```
The console output from the `startLiberty` task is output directly to the console.


## Testing the deployment
To test that the security schema is updated successfully, you can change the `user.registry.xml` file to add a user to your new or updated groups and connect to the Information Store in Analyst's Notebook Premium.

For more information about changing the `user.registry.xml` file, see [Administering user access](https://www.ibm.com/support/knowledgecenter/SSXVXZ/com.ibm.i2.eia.go.live.doc/security_users_addremove.html).
