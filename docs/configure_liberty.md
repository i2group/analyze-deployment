# Changing the memory allocation for Liberty
After you deploy your system, you might need to change the maximum Java virtual machine (JVM) memory allocation allowance for Liberty.

## Before you begin
Ensure that you can connect to the deployment and submit data by using Analyst's Notebook Premium.

## Modifying the `environment-advanced.properties` file
Modify the `environment-advanced.properties` in the `src/configuration/environment/opal-server` directory.

To change the JVM memory allocation, modify the value of the `was.heap.size` property. For example, `was.heap.size=4096`.

## Copying the configuration
Your changes are required by the Liberty server, this is the server that applies the changes.

The changed configuration must be copied to the `liberty` container. To use the docker `cp` function, the container must be running.

To copy, and overwrite, your configuration to the `liberty` container, run the following command from the `src` directory:
```
docker cp ./configuration/environment/opal-server/environment-advanced.properties liberty:/opt/IBM/i2analyze/toolkit/configuration/environment/opal-server/
```
The new configuration is now on the `liberty` container.

When the directory is copied, the owner of the directory, and all files within it, is changed. The user that runs the deployment script must be able to write to files within the `configuration` directory. To change the ownership of the directory and the files, run the following command:
```
docker exec -u root liberty chown -R i2analyze:i2analyze /opt/IBM/i2analyze/toolkit/configuration
```

In a non-Docker environment, copy the modified `environment-advanced.properties` file to the same location on the Liberty server and ensure that the correct permissions are set.

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
To test the deployment, connect to i2 Analyze from Analyst's Notebook Premium.
