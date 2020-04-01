# Change the database management system of your example
You can deploy the distributed example with the Information Store on IBM Db2 or Microsoft SQL Server. After you deploy your example, you can change the configuration so that the database is on the other management system.

When you run the script that changes the database management system of the deployment, the following tasks are completed:
- The required Docker images are built
- The required Docker containers are run
- The i2 Analyze configuration is updated
- The Information Store database is created
- i2 Analyze is deployed and started

This is process is not representative of an activity that you should complete in a non-Docker environment. In a non-Docker environment you must remove the initial deployment, and redeploy with your chosen database management system. The following process must only be used in the example Docker environment.

>Note: If you deployed the example with one of the configurations in the `configuration_mods` directory or changed the `topology.xml` file. Reset your example deployment to the base configuration before you deploy with Db2. To reset your environment, run the following command from the `src/scripts` directory:
```
./resetEnvironment
```

To change the database management system to use IBM Db2, see [Change the deployment to use IBM Db2](#change-the-deployment-to-use-ibm-db2).  
To change the database management system to use Microsoft SQL Server, see [Change the deployment to use Microsoft SQL Server](#change-the-deployment-to-use-microsoft-sql-server).

---
## Change the deployment to use IBM Db2

### Prerequisites for the distributed deployment example with IBM Db2
Download *IBM Db2 Advanced Edition for Linux* by using the following part numbers: *CC1U0ML* and *CC1VRML*.

Unzip the `DB2_DAE_Activation_11.5.zip` file, then copy the `adv_vpc` directory into the `src/images/db2/db2_installer` directory.

Rename the `DB2_Svr_11.5_Linux_x86-64.tar.gz` file to `DB2_AWSE_REST_Svr.tar.gz`, then copy it to the `src/images/db2/db2_installer/installation_media` directory. Do not decompress the file.

Download the SSL support file for Db2 by using the following part number: *CC1UPML*.

Rename the `DB2_SF_SSL_11.5_Linux_x86-64.tar.gz` file to `DB2_SF_SSLF.tar.gz`, then copy it to the `src/images/db2/base_client/installation_media` directory. Do not decompress the file.

Add the `db2jcc4.jar` file to the `src/configuration/environment/common/jdbc-drivers` directory.
>Note: In an installation of Db2, the `db2jcc4.jar` file is in the `IBM/SQLLIB/java` directory.  
If you do not have a Db2 installation, you can download the file. Download the file for `v11.5 FP0 (GA)`. For more information about downloading the `db2jcc4.jar` file, see: <http://www-01.ibm.com/support/docview.wss?uid=swg21363866>.


### Run the script to deploy with Db2
Navigate to the `src/scripts` directory, and run the following command:
```
./deployDb2
```

---
## Change the deployment to use Microsoft SQL Server
When you complete the quick deployment of the distributed example, the prerequisites for SQL Server are configured.

To change the deployment to use SQL Server, navigate to the `src/scripts` directory and run the following command:
```
./deploySqlServer
```

---

## Test the deployment
To test the deployment, connect to i2 Analyze from Analyst's Notebook Premium. The URL that you use to connect is: `http://i2demo:9082/opal`.

Log in using the user name `Jenny` with the password `Jenny`.

Use the **Upload records** functionality to add data to the Information Store, and then search for that data.
