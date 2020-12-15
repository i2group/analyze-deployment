# Changing the search results filtering
Modify the results filters in the i2 Analyze configuration, then redeploy the application server.

## Before you begin
Ensure that you can connect to the deployment and submit data by using Analyst's Notebook Premium.

To understand what search result filtering is, and why you might need to modify the filters, see [Setting up search results filtering](https://www.ibm.com/support/knowledgecenter/SSXVTH_latest/com.ibm.i2.eia.go.live.doc/t_property_facets.html).

## Modifying the results configuration file
The `law-enforcement-schema-results-configuration.xml` file in the distributed deployment example is in the following directory: `src/configuration/fragments/common/WEB-INF/classes`.

In an XML editor, open the `law-enforcement-schema-results-configuration.xml` file from the `classes` directory, and modify the filters that are available for an item type. After you modify the file, save your changes.

For more information about the results configuration file, see [Understanding the results configuration file](https://www.ibm.com/support/knowledgecenter/SSXVTH_latest/com.ibm.i2.eia.go.live.doc/understanding_facets_file.html).

## Copying the configuration
Your results configuration file changes are required by Liberty. The modified configuration must be copied to the Liberty server.

In a Docker environment, use the docker `cp` command to copy, and overwrite, your configuration to the running `liberty` container. In the `src` directory, run the following command:
```
docker cp ./configuration/fragments/common/WEB-INF/classes liberty:/opt/IBM/i2analyze/toolkit/configuration/fragments/common/WEB-INF/
```
The new configuration is now on the `liberty` container.

When the directory is copied, the owner of the directory, and all files within it, is changed. The user that runs the deployment script must be able to write to files within the `configuration` directory. To change the ownership of the directory and the files, run the following command:
```
docker exec -u root liberty chown -R i2analyze:i2analyze /opt/IBM/i2analyze/toolkit/configuration
```

In a non-Docker environment, copy the modified results configuration file to the same location on the Liberty server and ensure that the correct permissions are set.

## Updating the application
Run the following commands on the Liberty server to stop, deploy, and start Liberty:
```
docker exec -u i2analyze liberty /opt/IBM/i2analyze/toolkit/scripts/setup -t stopLiberty
```
```
docker exec -u i2analyze liberty /opt/IBM/i2analyze/toolkit/scripts/setup -t deployLiberty
```
```
docker exec -u i2analyze liberty /opt/IBM/i2analyze/toolkit/scripts/setup -t startLiberty
```

## Testing the deployment
To test that the results configuration is updated successfully, connect to the Information Store in Analyst's Notebook Premium.

After you connect and log in, complete a search that demonstrates if your results filter changes are applied.
