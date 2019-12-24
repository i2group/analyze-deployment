# Configuring ZooKeeper and i2 Analyze to use an SSH tunnel
To secure the connection between ZooKeeper and i2 Analyze, you configure an SSH tunnel to be used for communication between the servers. The following instructions detail what is required on each container, and how to use these steps to implement an SSH tunnel on a physical server.

## Before you begin
- Ensure that you can connect to the deployment and submit data by using Analyst's Notebook Premium.
- Ensure that all of the Docker containers are running.
- If you deployed the example with one of the configurations in the `configuration_mods` directory or changed the `topology.xml` file. Reset your example deployment to the base configuration before you configure ZooKeeper and i2 Analyze to use an SSH tunnel. To reset your environment, run the following command from the `src/scripts` directory:
```
./resetEnvironment
```

In a deployment of i2 Analyze, ZooKeeper acts as a server with Liberty and Solr connecting as clients. In the Docker distributed deployment example, the Admin Client also connects as a client.
An SSH tunnel enables secure connection between a client and server by using an SSH client and SSH server. For more information about SSH, see [SSH Tunnel](https://www.ssh.com/ssh/tunneling/).

## Prerequisites
The server that hosts ZooKeeper must have an implementation of SSH Server installed, the Liberty and Solr servers must have an implementation of SSH Client installed.

In the distributed example, OpenSSH is installed on the containers.

---

You can complete a quick tunneling setup or you can complete the tunneling setup manually. Completing the tunneling setup manually requires you to run each of the steps completed automatically in the quick tunneling setup so that you can replicate the steps in a non-Docker environment.

When SSL is enabled in your deployment, you cannot use the quick tunneling setup. You can either turn off SSL, or use the manual configuration instructions.

## Quick tunneling setup
To set up the tunneling in the distributed deployment example, a script is provided that configures the SSH tunnel, i2 Analyze, and ZooKeeper.

To configure SSH tunneling, run the `setupTunneling` script from the `src/scripts` directory.
```
./setupTunneling
```

The `setupTunneling` script prompts you for a number of passwords. You must provide passwords that are used to encrypt the SSH keys and for the *i2analyze* (UNIX password) user on the `zookeeper` container. When you are prompted for the `i2analyze@zookeeper` password, use the password that you specified for the *i2analyze* user.

You can choose the passphrase for the SSH keys. Whenever you are prompted for the passphrase, use this value. When you are using the `setupTunneling` script in the distributed deployment example, it is recommended to use the same passphrase for each key file. When you are prompted to specify the file to save the key to, press **Enter** to use the default value.

The SSH setup is completed and i2 Analyze is restarted. You can test the deployment by completing the steps in *Testing the deployment*.

---

## Securing ZooKeeper through SSH tunnel manually
### Stopping Liberty
Before you configure SSH tunneling, you must stop the application server.

To stop Liberty, run the following command on the `liberty` container:
```
docker exec -u i2analyze liberty /opt/IBM/i2analyze/toolkit/scripts/setup -t stopLiberty
```
The console output from the `stopLiberty` task is output directly to the console.

### Configuring the i2analyze user
Before you can configure the SSH Server, you must set up a password for the *i2analyze* user on the ZooKeeper container.

To set the *i2analyze* password, run the following command. Enter the new password when you are prompted:
```
docker exec -u root -it zookeeper passwd i2analyze
```

### Starting the SSH Server
To start the SSH Server, run the following command:
```
docker exec -u root zookeeper service ssh start
```
A message is displayed in the console when the SSH Server is started successfully.

### Generating and installing the SSH keys
You must generate an SSH key for each client, and then install the keys on the server.

To generate the keys for each client, run the following commands:
```
docker exec -u i2analyze -it solr ssh-keygen -t rsa
docker exec -u i2analyze -it solr2 ssh-keygen -t rsa
docker exec -u i2analyze -it liberty ssh-keygen -t rsa
docker exec -u i2analyze -it admin_client ssh-keygen -t rsa
```
When you are prompted to choose a file location for the key, press **Enter** to use the default value.
Choose a password for each key, and remember the value that you enter.

To install all the keys, run the following commands and enter the password for *i2analyze* user on the `zookeeper` container:
```
docker exec -u i2analyze -it solr ssh-copy-id i2analyze@zookeeper
docker exec -u i2analyze -it solr2 ssh-copy-id i2analyze@zookeeper
docker exec -u i2analyze -it liberty ssh-copy-id i2analyze@zookeeper
docker exec -u i2analyze -it admin_client ssh-copy-id i2analyze@zookeeper
```

### Creating the tunnel
A tunnel must be created on each of the clients to the server. The client requires the ZooKeeper server address. The port number for the tunnel must match the value that is specified in the `<zkhost>` element in the `topology.xml` file.

To create the tunnels, run the following commands:
```
docker exec -u i2analyze -d solr ssh -4 i2analyze@zookeeper -L 9983:zookeeper:9983 -N
docker exec -u i2analyze -d solr2 ssh -4 i2analyze@zookeeper -L 9983:zookeeper:9983 -N
docker exec -u i2analyze -d admin_client ssh -4 i2analyze@zookeeper -L 9983:zookeeper:9983 -N
docker exec -u i2analyze -d liberty ssh -4 i2analyze@zookeeper -L 9983:zookeeper:9983 -N
```

### Configuring i2 Analyze
Configure i2 Analyze to use the SSH tunnel. The `topology.xml` file must contain `secure-connection="true"` and `host-name="127.0.0.1"` attributes in the `<zookeeper` and `<zkhost>` elements.
In the distributed deployment example, you can see the configuration modifications in the `src/configuration_mods/<database>/tunneling` directory.

The `updateServerConfigurations` script copies a configuration to each of the example containers. To copy the tunneling configuration, run the following command:
```
./updateServerConfigurations tunneling
```

If your deployment uses SSL, you must manually update the `topology.xml` file with the required attributes on each container instead of running the `updateServerConfigurations` script.

### Uploading the new configuration to ZooKeeper
The changes to the way that Solr communicates with ZooKeeper must be uploaded to Zookeeper. To upload the new configuration, run the following command:
```
docker exec -u i2analyze zookeeper /opt/IBM/i2analyze/toolkit/scripts/setup -t createAndUploadSolrConfig --hostname 127.0.0.1
```

### Restarting the system
Each of the components in the deployment must be restarted to update the deployment. To restart the components, run the following commands:
```
docker exec -u i2analyze zookeeper /opt/IBM/i2analyze/toolkit/scripts/setup -t restartZkHosts --hostname 127.0.0.1

docker exec -u i2analyze solr /opt/IBM/i2analyze/toolkit/scripts/setup -t restartSolrNodes --hostname solr

docker exec -u i2analyze solr2 /opt/IBM/i2analyze/toolkit/scripts/setup -t restartSolrNodes --hostname solr2

docker exec -u i2analyze liberty /opt/IBM/i2analyze/toolkit/scripts/setup -t startLiberty
```

---

## Results
All the setup is completed and the application is started.

---

## Testing the deployment
To test the deployment was configured successfully, connect to i2 Analyze from Analyst's Notebook Premium. The URL that you use to connect is the same as you used to before you ran the upgrade process.

Log in using the user name `Jenny` with the password `Jenny`.

You can use the **Upload records** functionality to add data to the Information Store, and then search for that data or data that already existed.

Additionally, after the Solr node is running, you can use the Solr Web UI to inspect the configuration. Connect to the Solr Web UI on the `solr` container. In a web browser, go to the following URL to connect to the Solr Web UI: <http://localhost:8983/solr/#>. The user name is `solradmin` and the password is the Solr password set in the `credentials.properties` file. There the configuration points to `127.0.0.1` as Zookeeper host.
