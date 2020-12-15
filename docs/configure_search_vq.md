# Changing Visual Query conditions
Modify the Visual Query conditions file in the i2 Analyze configuration, then redeploy the application server.

## Before you begin
Ensure that you can connect to the deployment and submit data by using Analyst's Notebook Premium.

To understand what Visual Query conditions are, and why you might need to modify the conditions, see [Visual Query condition restrictions](https://www.ibm.com/support/knowledgecenter/SSXVTH_latest/com.ibm.i2.eia.go.live.doc/vq_understanding.html).

## Modifying the Visual Query conditions file
The `visual-query-configuration.xml` file in the distributed deployment example is in the following directory: `src/configuration/fragments/opal-services/WEB-INF/classes`.

In an XML editor, open the `visual-query-configuration.xml` file from the `classes` directory, and modify the Visual Query conditions. After you modify the file, save your changes.

For more information about the Visual Query conditions file, see [Visual Query condition restrictions](https://www.ibm.com/support/knowledgecenter/SSXVTH_latest/com.ibm.i2.eia.go.live.doc/vq_understanding.html).

## Updating the `DiscoServerSettingsCommon.properties` file
The `DiscoServerSettingsCommon.properties` file in the distributed deployment example is in the following directory: `src/configuration/fragments/opal-services/WEB-INF/classes`.

In a text editor, open the `DiscoServerSettingsCommon.properties` file and set the value of the `VisualQueryConfigurationResource` setting to `visual-query-configuration.xml`. For example: `VisualQueryConfigurationResource=visual-query-configuration.xml`.

After you modify the file, save your changes.

## Copying the configuration
Your Visual Query conditions file changes are required by Liberty. The modified configuration must be copied to the Liberty server.

In a Docker environment, use the docker `cp` command to copy, and overwrite, your configuration to the running `liberty` container. In the `src` directory, run the following command:
```
docker cp ./configuration/fragments/opal-services/WEB-INF/classes liberty:/opt/IBM/i2analyze/toolkit/configuration/fragments/opal-services/WEB-INF/
```
The new configuration is now on the `liberty` container.

When the directory is copied, the owner of the directory, and all files within it, is changed to `root`. The user that runs the deployment script must be able to write to files within the `configuration` directory. To change the ownership of the directory and the files, run the following command:
```
docker exec -u root liberty chown -R i2analyze:i2analyze /opt/IBM/i2analyze/toolkit/configuration
```

In a non-Docker environment, copy the modified `visual-query-configuration.xml` file to the same location on the Liberty server and ensure that the correct permissions are set.

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
To test that the Visual Query conditions are updated successfully, connect to the Information Store in Analyst's Notebook Premium.

After you connect and log in, complete a Visual Query search that demonstrates if your Visual Query condition changes are applied.
