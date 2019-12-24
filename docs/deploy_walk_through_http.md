# Deploying the distributed deployment example with IBM HTTP Server
To deploy the distributed deployment example in a topology that uses the IBM HTTP Server. The following instructions detail what is required on each container, and how to use these steps to deploy i2 Analyze on physical servers.

## Before you begin
- Complete the [Quick deploy](deploy_quick_start.md) section and your deployment must be running.
- If you deployed the example with one of the configurations in the `configuration_mods` directory or changed the `topology.xml` file. Reset your example deployment to the base configuration before you deploy with IBM HTTP Server. To reset your environment, run the following command from the `src/scripts` directory:
```
./resetEnvironment
```

You must run all Docker commands from a command line where Docker is initialized.

## Deploying i2 Analyze with IBM HTTP Server
In the distributed deployment example, the IBM HTTP Server is deployed in its own server.

In the Docker environment, the `ihs_image` is created when you run the `buildImages` script. The IBM HTTP Server container is started when you run the `runContainers` script. If you cleaned your environment, rebuild and run the container.
To build the IBM HTTP Server image, run the following command from the `src/images` folder:
```
docker build -t ihs_image common/ihs
```

The IBM HTTP Server image is created with the name `ihs_image`.

To run the IBM HTTP Server container, run the following command:
```
docker run -d --name ihs -h ihs -p 80:80 -p 443:443 --net eianet -u root ihs_image
```

### Modifying the configuration
The current configuration is set up for a deployment that does not use the HTTP Server. You must update the configuration on each of the containers. To update the configurations, run the `updateServerConfigurations` script from the `scripts` directory:
```
./updateServerConfigurations ihs
```

The configuration is now on each container.

In a non-Docker environment, modify each configuration to match the configuration in the `src/configuration_mods/<database management system>/ihs` directory.

### Redeploying and starting the components of i2 Analyze
After the configuration is present on each server, you must redeploy and start each component of i2 Analyze.

You must redeploy and start the components of a deployment in the order that they are described here.

#### Stopping Liberty
To stop Liberty, run the following command on the `liberty` container:
```
docker exec -u i2analyze liberty /opt/IBM/i2analyze/toolkit/scripts/setup -t stopLiberty
```
The console output from the `stopLiberty` task is output directly to the console.

#### Deploying Liberty
To deploy Liberty, run following command on the `liberty` container:
```
docker exec -u i2analyze liberty /opt/IBM/i2analyze/toolkit/scripts/setup -t deployLiberty
```

#### Configuring the HTTP Server
To configure the IBM HTTP Server, run the following command on the `ihs` container:
```
docker exec -u root ihs /opt/IBM/i2analyze/toolkit/scripts/setup -t configureHttpServer
```

To configure the IBM HTTP Server plugin configuration, copy the configured file to the `ihs` container. To copy the plugin file, run the following command on the `ihs` container:
```
docker exec -u root ihs sh -c "cp /opt/IBM/i2analyze/toolkit/configuration/plugin-cfg.xml /opt/IBM/HTTPServer/plugins/iap/config/plugin-cfg.xml"
```

#### Starting Liberty
To start Liberty, run the following command on the `liberty` container:
```
docker exec -u i2analyze liberty /opt/IBM/i2analyze/toolkit/scripts/setup -t startLiberty
```
The console output from the `startLiberty` task is output directly to the console.

#### Restarting the HTTP Server
To restart the HTTP Server, run the following command on the `ihs` container:
```
docker exec -u root ihs sh -c "/opt/IBM/HTTPServer/bin/apachectl restart"
```

## Results
All of the components of i2 Analyze are installed, including IBM HTTP Server and the application is started.

---

## Testing the deployment
To test the deployment was installed successfully with IBM HTTP Server, connect to i2 Analyze from Analyst's Notebook Premium. The URL that you use to connect is: [http://i2demo/opal](http://i2demo/opal).

Log in using the user name `Jenny` with the password `Jenny`.

You can use the **Upload records** functionality to add data to the Information Store, and then search for that data or data that already existed.
