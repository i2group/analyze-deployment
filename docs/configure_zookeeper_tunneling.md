# Configuring ZooKeeper and i2 Analyze to use an SSH tunnel
To secure the connection between ZooKeeper and i2 Analyze, you configure an SSH tunnel to be used for communication between the servers. The following instructions detail what is required on each container, and how to use these steps to implement SSH tunnels on physical servers.

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
The servers that host ZooKeeper must have an implementation of SSH Server installed, the Liberty and Solr servers must have an implementation of SSH Client installed.

In the distributed example, OpenSSH is installed on the containers.

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
Before you can configure the SSH Server, you must set up a password for the *i2analyze* user on the ZooKeeper containers.

To set the *i2analyze* password, run the following commands on each container. Enter the new password when you are prompted:
```
docker exec -u root -it zookeeper passwd i2analyze
docker exec -u root -it zookeeper2 passwd i2analyze
docker exec -u root -it zookeeper3 passwd i2analyze
```

### Starting the SSH Server
To start the SSH Server on the Zookeeper containers, run the following commands:
```
docker exec -u root zookeeper service ssh start
docker exec -u root zookeeper2 service ssh start
docker exec -u root zookeeper3 service ssh start
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

To install all of the keys, run the following commands for each client and enter the password for the *i2analyze* user on the `zookeeper`, `zookeeper2` or `zookeeper3` containers:
```
docker exec -u i2analyze -it solr ssh-copy-id i2analyze@zookeeper
docker exec -u i2analyze -it solr ssh-copy-id i2analyze@zookeeper2
docker exec -u i2analyze -it solr ssh-copy-id i2analyze@zookeeper3

docker exec -u i2analyze -it solr2 ssh-copy-id i2analyze@zookeeper
docker exec -u i2analyze -it solr2 ssh-copy-id i2analyze@zookeeper2
docker exec -u i2analyze -it solr2 ssh-copy-id i2analyze@zookeeper3

docker exec -u i2analyze -it liberty ssh-copy-id i2analyze@zookeeper
docker exec -u i2analyze -it liberty ssh-copy-id i2analyze@zookeeper2
docker exec -u i2analyze -it liberty ssh-copy-id i2analyze@zookeeper3

docker exec -u i2analyze -it admin_client ssh-copy-id i2analyze@zookeeper
docker exec -u i2analyze -it admin_client ssh-copy-id i2analyze@zookeeper2
docker exec -u i2analyze -it admin_client ssh-copy-id i2analyze@zookeeper3
```

On Windows, the `ssh-copy-id` utility is not available in every distribution of SSH. You can find tools or commands that perform the same action available online.

### Creating the tunnel
A tunnel must be created on each of the clients to each of the SSH secured servers. The client requires the ZooKeeper server address. The port number for the tunnel must match the value that is specified in the `<zkhost>` element in the `topology.xml` file.

To create a tunnel, the password for the i2 Analyze user is required. When you run the command in interactive mode (`-it`), you can enter the password. After the tunnel is created, detach from the process so that the tunnel remains in place. Use `Ctrl + p`, `Ctrl + q` to detach from the process.

When the tunnel is created, no message is displayed in the console.

To create the tunnels, run the following commands:
```
docker exec -u i2analyze -it solr ssh -4 i2analyze@zookeeper -L 9983:zookeeper:9983 -N
ctrl + p ctrl + q
docker exec -u i2analyze -it solr ssh -4 i2analyze@zookeeper2 -L 9984:zookeeper2:9984 -N
ctrl + p ctrl + q
docker exec -u i2analyze -it solr ssh -4 i2analyze@zookeeper3 -L 9985:zookeeper3:9985 -N
ctrl + p ctrl + q

docker exec -u i2analyze -it solr2 ssh -4 i2analyze@zookeeper -L 9983:zookeeper:9983 -N
ctrl + p ctrl + q
docker exec -u i2analyze -it solr2 ssh -4 i2analyze@zookeeper2 -L 9984:zookeeper2:9984 -N
ctrl + p ctrl + q
docker exec -u i2analyze -it solr2 ssh -4 i2analyze@zookeeper3 -L 9985:zookeeper3:9985 -N
ctrl + p ctrl + q

docker exec -u i2analyze -it admin_client ssh -4 i2analyze@zookeeper -L 9983:zookeeper:9983 -N
ctrl + p ctrl + q
docker exec -u i2analyze -it admin_client ssh -4 i2analyze@zookeeper2 -L 9984:zookeeper2:9984 -N
ctrl + p ctrl + q
docker exec -u i2analyze -it admin_client ssh -4 i2analyze@zookeeper3 -L 9985:zookeeper3:9985 -N
ctrl + p ctrl + q

docker exec -u i2analyze -it liberty ssh -4 i2analyze@zookeeper -L 9983:zookeeper:9983 -N
ctrl + p ctrl + q
docker exec -u i2analyze -it liberty ssh -4 i2analyze@zookeeper2 -L 9984:zookeeper2:9984 -N
ctrl + p ctrl + q
docker exec -u i2analyze -it liberty ssh -4 i2analyze@zookeeper3 -L 9985:zookeeper3:9985 -N
ctrl + p ctrl + q
```

### Configuring i2 Analyze
Configure i2 Analyze to use the SSH tunnel. The `topology.xml` file must contain the `secure-connection="true"` attribute in the `<zookeeper>` element and the `host-name="127.0.0.1"` attribute in each  `<zkhost>` element.  
In the distributed deployment example, you can see the configuration modifications in the `src/configuration_mods/<database>/tunneling` directory.

The `updateServerConfigurations` script copies a configuration to each of the example containers. To copy the tunneling configuration, run the following command:
```
./updateServerConfigurations tunneling
```

In a non-Docker environment, copy the changes to the ZooKeeper elements to each server in your deployment.

When you have a ZooKeeper quorum, more that one ZooKeeper server, you must update the `topology.xml` file on each ZooKeeper server to comment out the the `<zkhost>` elements for the ZooKeepers that are located on other servers. This step is required because each ZooKeeper server has the host name `127.0.0.1`, and when you run a toolkit task with that host name it attempts to perform the desired action on all of the ZooKeeper server. On the Liberty and Solr servers, retain the `topology.xml` file that defines all the ZooKeeper servers in the deployment.

Note: Do not run `createZkHosts` or `uploadSolrConfiguration` from any of the ZooKeeper servers.


If your deployment uses SSL, you must manually update the `topology.xml` file with the required attributes on each container instead of running the `updateServerConfigurations` script.

### Uploading the new configuration to ZooKeeper
The changes to the way that Solr communicates with ZooKeeper must be uploaded to Zookeeper. To upload the new configuration, run the following command from the Liberty or Admin Client containers:
```
docker exec -u i2analyze admin_client /opt/IBM/i2analyze/toolkit/scripts/setup -t createAndUploadSolrConfig --hostname admin_client
```

### Restarting the system
Each of the components in the deployment must be restarted to update the deployment. To restart the components, run the following commands:
```
docker exec -u i2analyze zookeeper /opt/IBM/i2analyze/toolkit/scripts/setup -t restartZkHosts --hostname 127.0.0.1
docker exec -u i2analyze zookeeper2 /opt/IBM/i2analyze/toolkit/scripts/setup -t restartZkHosts --hostname 127.0.0.1
docker exec -u i2analyze zookeeper3 /opt/IBM/i2analyze/toolkit/scripts/setup -t restartZkHosts --hostname 127.0.0.1

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

Additionally, after the Solr node is running, you can use the Solr Web UI to inspect the configuration. Connect to the Solr Web UI on the `solr` container. In a web browser, go to the following URL to connect to the Solr Web UI: <http://localhost:8983/solr/#>. The user name is `solradmin` and the password is the Solr password set in the `credentials.properties` file. There the configuration points to `127.0.0.1` as ZooKeeper hosts.
