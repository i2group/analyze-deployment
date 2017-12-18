# Quick deploy
To deploy the distributed deployment example, scripts are provided that copy any prerequisites and build the docker images, then run the docker containers automatically.
>**Important**: The distributed example uses a Docker environment to demonstrate a distributed deployment of i2 Analyze. The Docker environment is not designed to be used on customer sites for test or production systems. After you understand how the distributed deployment is deployed, replicate the deployment on physical servers.

>Note: To deploy the distributed deployment example manually with detailed explanation about all of the steps, see [Deploying the example manually](deploy_walk_through.md).

>Note: If you have deployed the distributed deployment example previously, ensure that you clean your environment before you start the manual deployment. For information about how to clean your system, see [Cleaning your environment](deploy_clean_environment.md).

## Prerequisites for the distributed deployment example
Download, install, and configure the prerequisites for the distributed deployment example.

### Bash shell
The scripts that are used in the distributed deployment example are Shell scripts. If you are running the distributed deployment example on Windows, you must be able to run Shell scripts.

To run Shell scripts, you can use Cygwin. You can download Cygwin from [https://www.cygwin.com/](https://www.cygwin.com/). When you install Cygwin, ensure that you install the Bash plugin. After you install Cygwin, add `bin` directory of the install to your path environment variable.

When you run the scripts, preface the command with `bash`.

### Docker
You must install *Docker CE* for your operating system. For information about installing Docker CE, see <https://docs.docker.com/engine/installation/>.

>If you are using Windows 7, you must install Docker Toolbox. For information about installing Docker Toolbox, see <https://docs.docker.com/toolbox/overview/>.  
If you are using Windows 7, use Oracle Virtual Box to host your Docker virtual machine.

After you install Docker, you must ensure that your command line environment has Docker initialized.

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
Clone or download the distributed deployment example from <https://github.ibm.com/ibmi2/distributedExample/releases/tag/v2.0>.

### DB2
Download *IBM DB2 Advanced Workgroup Server Edition for Linux* using the following part numbers: *CNB21ML* and *CNB8FML*.

Unzip the `DB2_AWSE_Restricted_Activation_11.1.zip` file, then copy the `awse_o` directory into the `src/images/db2_installer` directory.

Rename the `DB2_AWSE_REST_Svr_11.1_Lnx_86-64.tar.gz` file to `DB2_AWSE_REST_Svr.tar.gz`, then copy it to the `src/images/db2_installer/installation_media` directory. Do not uncompress the file.

Download the SSL support file for DB2 using the following part number: *CNS6QML*.

Rename the `DB2_SF_SSLF_V11.1_Linux_x86-64.tar.gz` file to `DB2_SF_SSLF.tar.gz`, then copy it to the `src/images/base_client/installation_media` directory. Do no uncompress the file.

### Analyst's Notebook Premium
Download *i2 Analyst's Notebook Premium* using the following part number: *CNSL4ML*.

Install Analyst's Notebook Premium with the Opal connector on a Windows machine that can access the machine where Docker is running.

>Note: If you are running Docker on Mac OS, you can install Analyst's Notebook Premium on a Windows virtual machine.

For more information, see [Installing IBM i2 Analyst's Notebook Premium](https://www.ibm.com/support/knowledgecenter/SSXVXZ/com.ibm.i2.eia.install.doc/installing_anbp.html).

### i2 Analyze
Download i2 Analyze for Linux. You download the IBM i2 Analyze (Archive install) for Linux using part number *CNSL7ML*, or the IBM i2 Enterprise Insight Analysis (Archive install) for Linux using part number *CNSZ0ML*.

Depending on the download that you used, rename the `I2_ANA_4.2.0__ARCHIVE_INSTALL_LIN.gz` or `I2_EIA_2.2.0_ARCHIVE_INSTALL_LINU.gz` file to `i2analyze.tar.gz`, then copy it to the `src/images/ubuntu_toolkit/i2analyze` directory.

Accept the license, open `i2analyze/license_acknowledgment.txt` and change the value of `LIC_AGREEMENT` to `ACCEPT`.

Add the `db2jcc4.jar` file to the `src/configuration/environment/common/jdbc-drivers` directory.
>Note: In an installation of DB2, the `db2jcc4.jar` file is in the `IBM/SQLLIB/java` directory.  
If you do not have a DB2 installation, you can download the file. Download the file for `v11.1 M2 FP2 iFix1`. For more information about downloading the `db2jcc4.jar` file, see: <http://www-01.ibm.com/support/docview.wss?uid=swg21363866>.

### Specifying the credentials
You must specify the credentials for a deployment in the `src/configuration/environment/credentials.properties`. Set the passwords to be used for DB2, Solr, and the LTPA keys.

For more information about the credentials file, see [Modifying the credentials](https://www.ibm.com/support/knowledgecenter/SSXVXZ/com.ibm.i2.eia.go.live.doc/t_specifying_credentials.html).
To complete the quick deployment, enter passwords for the `db.infostore.password`, `solr.password`, and `ltpakeys.password` credentials.

---
## Build the Docker images    
In the `src/scripts` directory, run the `buildImages` file.

The first time that you run this script, it might take about 15 minutes to complete. Subsequently, a cache is used and this process is quicker.

>Important: You can ignore any warnings about the `db2prereqcheck` utility failing.

Check that the images built correctly using the Docker `images` command:
```
docker images
```
The following images must be listed: `base_client_image`, `zookeeper_image`,  `solr_image`, `solr2_image`, `admin_client_image`, `liberty_image`, `db2_installer_image`, `db2_image`, and `ubuntu_toolkit_image`.

## Run the Docker containers  
Run the `runContainers` file.

You are prompted to enter a password for the `i2analyze` user. Enter the password that you specified in the `credentials.properties` file for the `db2.infostore.password` credential.

After the script in the `runContainers` file completes, all the containers are run and i2 Analyze is deployed.

---

## Test the deployment
To test the deployment, connect to i2 Analyze from Analyst's Notebook Premium. The URL that you use to connect is: `http://i2demo:9082/opal`.

Log in using the user name `Jenny` with the password `Jenny`.

Use the **Upload records** functionality to add data to the Information Store, and then search for that data.

To configure Windows to connect to the Docker container using the above URL, you must change the `hosts` file.  
Open a command prompt as ADMINISTRATOR, and navigate to the following location:
`C:\Windows\System32\drivers\etc`.

Open the `hosts` file in a text editor. At the bottom of the file, add your IP Address followed by `i2demo`. For example:
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
To understand the distributed deployment example, what is deployed, and how it is deployed, complete the detailed instructions in [deploying the example manually](deploy_walk_through.md).
