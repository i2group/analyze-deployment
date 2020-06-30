# Deploying the distributed deployment example with SSL
You can deploy the distributed deployment example with additional security configured. You can use the scripts and configurations that are provided to understand how to deploy with security in a non-Docker environment.

## Before you begin
- You must complete the [Quick deploy](deploy_quick_start.md) or deploy the example manually, and your deployment must be running.
- If you deployed the example with one of the configurations in the `configuration_mods` directory or changed the `topology.xml` file. Reset your example deployment to the base configuration before you deploy with security. To reset your environment, run the following command from the `src/scripts` directory:
```
./resetEnvironment
```

---

## Choosing a configuration
There are a number of secure configurations that you can choose to deploy:
- **ssl**  
This configuration deploys with SSL configured between each of the distributed components in an i2 Analyze deployment.
- **ihs_ssl**  
This configuration deploys with SSL configured between each of the distributed components in an i2 Analyze deployment that includes the IBM HTTP Server.  
For information about configuring SSL with i2 Analyze, see [Secure Sockets Layer connections with i2 Analyze](https://www.ibm.com/support/knowledgecenter/SSXVXZ/com.ibm.i2.eia.go.live.doc/c_kc_intro_ssl.html)
- **client_cert_ssl**  
This configuration deploys with SSL configured between each of the distributed components in an i2 Analyze deployment that includes the IBM HTTP Server. The user can log in to the system by using a client certificate.  
For more information about configuring client certificate authentication, see [Configuring X.509 client certificate authentication with i2 Analyze](https://www.ibm.com/support/knowledgecenter/SSXVXZ/com.ibm.i2.eia.go.live.doc/c_kc_intro_x509.html)

## Creating the keystores and certificates
Run the `createKeysAndStores` script to create the stores, certificates, and certificate authority. For example, run the following command from the `src/scripts` directory:
```
./createKeysAndStores
```
You are prompted to enter a password that is used for each of the keystores and truststores that are created. The password that you specify here is used later.

For more information about the stores and certificates that are created, see [Keystores and certificates for components of i2 Analyze](./securing_certificates.md).

### Specifying the credentials
You must specify the credentials for your deployment in the `src/configuration/environment/credentials.properties`. Set the passwords to use for each of the keystore and truststore credentials. The passwords must match the value that you entered when you ran the `createKeysAndStores` script.

For more information about the credentials file, see [Modifying the credentials](https://www.ibm.com/support/knowledgecenter/SSXVXZ/com.ibm.i2.eia.go.live.doc/t_specifying_credentials.html).

## Updating your deployment to use a secure configuration
Run the `setupSecurity` script, and pass the name of the configuration as a parameter. For example, to update the deployment with the **ssl** configuration, run the following command from the `src/scripts` directory:
```
./setupSecurity ssl
```

## Results
The deployment of i2 Analyze is updated with your chosen configuration. Any connections that are secured by using SSL use the certificates and stores that are present on each server.

## Connecting to Analyst's Notebook Premium
To connect to i2 Analyze in a deployment that uses SSL, you must use a different URL. The URL that you use to connect is: [https://i2demo:9445/opal](https://i2demo:9445/opal).
The protocol is changed to `https`, and the port number is changed to `9445`.

>For Windows 7, you must also forward the required ports from your local machine to the virtual machine that hosts Docker.  
>In the network settings for your Docker virtual machine, open the **Advanced** menu and click **Port Forwarding**. Create a new line, and enter values for the `Host IP`, `Host Port`, and `Guest Port`. To connect to i2 Analyze, set the value of `Guest Port` to `9445`.

>Note: If you are using a configuration with the IBM HTTP Server, you must not specify the port number. For example, [https://i2demo/opal](https://i2demo/opal).

## Learning how to deploy the configuration in a non-Docker environment
To understand the differences between the configurations, and the base configuration, you can use a file comparison tool. You can see which properties files are modified, and the configuration settings that are required. For detailed explanations of the properties and the process for changing them, you can use the information that is provided in IBM Knowledge Center.

For information about securing the components of i2 Analyze, see [Secure Sockets Layer connections with i2 Analyze](https://www.ibm.com/support/knowledgecenter/SSXVXZ/com.ibm.i2.eia.go.live.doc/c_kc_intro_ssl.html) and [Configuring X.509 client certificate authentication with i2 Analyze](https://www.ibm.com/support/knowledgecenter/SSXVXZ/com.ibm.i2.eia.go.live.doc/c_kc_intro_x509.html).

To see the toolkit commands that are run to deploy the components of i2 Analyze in a secure deployment, you can inspect the `setupSecurity` script.

The instructions in IBM Knowledge Center use self-signed certificates to demonstrate securing a deployment. For more information about using certificates that are signed by certificate authority, see [Keystores and certificates for components of i2 Analyze](./securing_certificates.md).
