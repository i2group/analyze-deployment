# Quick deploy
To deploy the distributed deployment example, scripts are provided that copy any prerequisites and build the docker images, then run the docker containers automatically.
>**Important**: The distributed example uses a Docker environment to demonstrate a distributed deployment of i2 Analyze. The Docker environment is not designed to be used on customer sites for test or production systems. After you understand how the distributed deployment is deployed, replicate the deployment on physical servers.

>Note: To deploy the distributed deployment example manually with detailed explanation about all of the steps, see [Deploying the example manually on SQL Server](deploy_walk_through_sqlserver.md) and [Deploying the example manually on Db2](deploy_walk_through_db2.md).

>Note: If you deployed the distributed deployment example previously, ensure that you clean your environment before you start the manual deployment. For more information about how to clean your system, see [Cleaning your environment](deploy_clean_environment.md).

## Prerequisites for the distributed deployment example
Download, install, and configure the prerequisites for the distributed deployment example.

### Bash shell
The scripts that are used in the distributed deployment example are Shell scripts. If you are running the distributed deployment example on Windows, you must be able to run Shell scripts.

To run Shell scripts, you can use Cygwin. You can download Cygwin from [https://www.cygwin.com/](https://www.cygwin.com/). When you install Cygwin, ensure that you install the Bash plugin. After you install Cygwin, add the `bin` directory of the installation to your path environment variable.

To run the scripts in the distributed example, start `Cygwin.bat` from the command line in the `cygwin64` directory.

### Docker
You must install *Docker CE* for your operating system. For more information about installing Docker CE, see <https://docs.docker.com/engine/installation/>.

>If you are using Windows 7, you must install Docker Toolbox. For information about installing Docker Toolbox, see <https://docs.docker.com/toolbox/overview/>.  
If you are using Windows 7, use Oracle Virtual Box to host your Docker virtual machine.

After you install Docker, you must ensure that is Docker initialized in your command line environment.

>If you are using Windows 7, you must run the following command to initialize the Docker command line environment in your console:   
> ```
> @FOR /f "tokens=*" %i IN ('docker-machine env --shell cmd default') DO @%i
> ```
> Where *default* is the name of your virtual machine.


 To test that your Docker command line environment is initialized correctly, run the following command:  
 ```
 docker run hello-world
 ```

### Example code
Clone or download the distributed deployment example from <https://github.com/IBM-i2/Analyze-Deployment/releases>.

### Analyst's Notebook Premium
Download *i2 Analyst's Notebook Premium* from Fix Central: [Download IBM i2 Analyst's Notebook Premium 9.2.1 Fix Pack 1](http://www.ibm.com/support/docview.wss?uid=ibm1283782).

Install Analyst's Notebook Premium with the Opal connector on a Windows machine that can access the machine where Docker is running.

>Note: If you are running Docker on Mac OS, you can install Analyst's Notebook Premium on a Windows virtual machine.

For more information, see [Installing IBM i2 Analyst's Notebook Premium](https://www.ibm.com/support/knowledgecenter/SSXVXZ/com.ibm.i2.deploy.example.doc/installing_anbp.html).

### i2 Analyze
Download i2 Analyze for Linux. You download the `IBM_i2_Analyze_4.3.1_Fix_Pack_1_Linux_Archive.tar.gz` from Fix Central: [Download IBM i2 Analyze 4.3.1 Fix Pack 1](https://www.ibm.com/support/pages/node/1283776).

Rename the `.tar.gz` file to `i2analyze.tar.gz`, then copy it to the `src/images/common/ubuntu_toolkit/i2analyze` directory.

Accept the license, open `license_acknowledgment.txt` in the `src/images/common/ubuntu_toolkit/i2analyze` directory and change the value of `LIC_AGREEMENT` to `ACCEPT`.

Add the `mssql-jdbc-7.4.1.jre8.jar` file to the `src/configuration/environment/common/jdbc-drivers` directory.  
You must create the `common/jdbc-drivers` directories.
>Note: Download the Microsoft JDBC Driver 7.4 for SQL Server from [Microsoft JDBC Driver 7.4 for SQL Server](https://www.microsoft.com/en-us/download/details.aspx?id=58505). Extract the contents of the `tar.gz`, and locate the `sqljdbc_7.4\enu\mssql-jdbc-7.4.1.jre8.jar` file.

### Specifying the credentials
You must specify the credentials for a deployment in the `src/configuration/environment/credentials.properties`. Set the passwords to be used for the Information Store, Solr, and the LTPA keys.

For more information about the credentials file, see [Modifying the credentials](https://www.ibm.com/support/knowledgecenter/SSXVXZ/com.ibm.i2.eia.go.live.doc/t_specifying_credentials.html).
To complete the quick deployment, enter passwords for the `db.infostore.password`, `solr.password`, and `ltpakeys.password` credentials.

---
## Build the Docker images
In the `src/scripts` directory, run the `buildImages` file:
```
./buildImages
```

The first time that you run this script, it might take about 15 minutes to complete. After, a cache is used and this process is quicker.

Check that the images built correctly by using the Docker `images` command:
```
docker images
```
The following images must be listed: `mcr.microsoft.com/mssql/server`, `zookeeper_image`, `zookeeper2_image`, `zookeeper3_image`, `solr_image`, `solr2_image`, `admin_client_sqlserver_image`, `liberty_sqlserver_image`, and `ubuntu_toolkit_image`.

## Run the Docker containers
In the `src/scripts` directory, run the `runContainers` file:
```
./runContainers
```
You are prompted to enter a password for the `SA` user, this is the system administrator user for the SQL Server container. The password that you specify must be at least 8 characters long and contain characters from three of the following four sets: Uppercase letters, Lowercase letters, Base 10 digits, and Symbols.

You are prompted to enter a password for the `i2analyze` user. Enter the password that you specified in the `credentials.properties` file for the `db.infostore.password` credential.

After the script in the `runContainers` file completes, all the containers are run and i2 Analyze is deployed.

---

## Test the deployment
To test the deployment, connect to i2 Analyze from Analyst's Notebook Premium. The URL that you use to connect is: `http://i2demo:9082/opal`.

Log in using the user name `Jenny` with the password `Jenny`.

Use the **Upload records** functionality to add data to the Information Store, and then search for that data.

To configure Windows to connect to the Docker container by using the specified URL, you must change the `hosts` file.  
Open a command prompt as ADMINISTRATOR, and navigate to the following location:
`C:\Windows\System32\drivers\etc`.

Open the `hosts` file in a text editor. At the end of the file, add your IP Address followed by `i2demo`. For example:
```
127.0.0.1 i2demo
```

>Note: You must run Analyst's Notebook Premium on Windows. If you deploy the distributed deployment example on MAC, you can use a Windows virtual machine to host Analyst's Notebook Premium. For your virtual machine to connect to i2 Analyze, complete the following:  
>On your MAC terminal, run `ifconfig` and identify the IP address for your virtual machine in a section such as `vmnet1`. For example, `172.16.100.1`.  
>Then, on your Windows virtual machine add the following line to the `C:\Windows\System32\drivers\etc\hosts` file:
>```
>172.16.100.1 i2demo
>```


>For Windows 7, you must also forward the required ports from your local machine to the virtual machine that hosts Docker.  
>In the network settings for your docker virtual machine, open the **Advanced** menu and click **Port Forwarding**. Create a new line, and enter values for the `Host IP`, `Host Port`, and `Guest Port`. To connect to i2 Analyze, set the value of `Guest Port` to `9082`.

---
## What to do next
To understand the distributed deployment example, what is deployed, and how it is deployed, complete the detailed instructions in [deploying the example manually](deploy_walk_through_sqlserver.md).
