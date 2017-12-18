# Updating the Schema
In a deployment of i2 Analyze, the database structure is defined by a schema. To update the schema, you must update the database and then restart Liberty to load the updated schema. Solr requires no changes.

## Before you begin
- Ensure that you can connect to the deployment with the current schema, and submit data using Analyst's Notebook Premium.
- Ensure that all of the Docker containers are running.

## Modifying the schema file
In the distributed deployment example, the `law-enforcement-schema.xml` and `law-enforcement-charting-schemes.xml` files that represents the i2 Analyze schema are in the following directory: `src/configuration/fragments/common/WEB-INF/classes`.

In Schema Designer, open the `law-enforcement-schema.xml` file from the `classes` directory, and make additive changes to the schema. After you modify the schema, save your changes and close Schema Designer.

## Copying the configuration
In the distributed deployment example, the schema and charting schemes changes are completed on the Admin client and Liberty containers. To update the deployment with the changes, you must run toolkit tasks that interact with the Information Store database and the i2 Analyze application.

The changed configuration must be copied to the `admin_client` and `liberty` containers.

To copy, and overwrite, your configuration to the `admin_client` and `liberty` containers, run the following commands from the `src` directory:
```
docker cp ./configuration admin_client:/opt/IBM/i2analyze/toolkit/
docker cp ./configuration liberty:/opt/IBM/i2analyze/toolkit/
```
The new configuration is now on the `admin_client` and `liberty` containers.

When the directory is copied, the owner of the directory, and all files within it, is changed. The user that runs the deployment script must be able to write to files within the `configuration` directory. To change the ownership of the directory and the files, run the following commands:
```
docker exec -u root admin_client chown -R i2analyze:db2iusr1 /opt/IBM/i2analyze/toolkit/configuration
docker exec -u root liberty chown -R i2analyze:db2iusr1 /opt/IBM/i2analyze/toolkit/configuration
```

In a non-Docker environment, copy the `law-enforcement-schema.xml` and `law-enforcement-charting-schemes.xml` files to the same location on the Liberty server and ensure that the correct permissions are set.

## Stopping Liberty
Before you update the Information Store with your modified schema, you must stop the application server.

You can shutdown the application using the `stopLiberty` i2 Analyze toolkit task. In this distributed deployment example, run the i2 Analyze toolkit commands in the `liberty` Docker container. To run the command in the `liberty` Docker container, run the following command:
```
docker exec -u i2analyze liberty /opt/IBM/i2analyze/toolkit/scripts/setup -t stopLiberty
```
The output from the `stopLiberty` task is output directly to the console.

## Updating the database
Update the database to conform to the updated schema.

To update the schema, you can run the command from the Admin client or Liberty server. In this distributed deployment example, the Admin client is used to run the commands.

To update the database to conform to the updated schema, run the following command:
```
docker exec -u i2analyze -t admin_client /opt/IBM/i2analyze/toolkit/scripts/setup -t updateInformationStoreSchema
```
## Updating the application
You must update the application with the modified `law-enforcement-charting-schemes.xml` file.

Run the following commands on the Liberty server to deploy Liberty:

```
docker exec -u i2analyze liberty /opt/IBM/i2analyze/toolkit/scripts/setup -t deployLiberty
```

## Starting Liberty
Start Liberty to load the updated schema and charting scheme:  

Run the following command to start Liberty:
```
docker exec -u i2analyze -d liberty /opt/IBM/i2analyze/toolkit/scripts/setup -t startLiberty
```
The console output from the `startLiberty` task is output directly to the console.

## Testing the deployment
To test that the schema is updated successfully, connect to the Information Store in Analyst's Notebook Premium.

After you connect and log in, a message is displayed that informs you of a schema change. The changes that you made to the schema are visible in the palette, and available for you to use.

## What to do next
After you modify the schema, you might need to modify the filters that users see during Quick Search and Visual Query operations. For more information, see [Changing the search results filtering](configure_search_facets.md).
