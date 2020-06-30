# Resetting the system
During development, to make destructive schema changes or to completely change your schema, you must recreate the Information Store database.

## Before you begin
This process can permanently remove data and the database from your system, ensure that no data is in the system that you want to keep.

For more information about making a backup of your deployment, see [Backing up a deployment](https://www.ibm.com/support/knowledgecenter/SSXVXZ/com.ibm.i2.eia.go.live.doc/c_back_up_and_recovery.html).

## Stopping Liberty
Run the following command on the Liberty server to stop Liberty:
```
docker exec -u i2analyze liberty /opt/IBM/i2analyze/toolkit/scripts/setup -t stopLiberty
```
The console output from the `stopLiberty` task is output directly to the console.

## Clearing the search index
To clear the search index, you can run the commands from the Admin client or Liberty server. In the distributed deployment example, the `admin_client` container is used to run the command. The `admin_client` container includes the i2 Analyze toolkit and a database management system client installation. You can run commands that modify the database and Solr from this container.

To clear the search index, run the following command:
```
docker exec -u i2analyze -it admin_client /opt/IBM/i2analyze/toolkit/scripts/setup -t clearSearchIndex --all --hostname admin_client.eianet
```

The search index is cleared, however any data that was in the database remains in the database.

## Removing databases from the system
To remove the database from your system, you can use the `dropDatabases` toolkit task. For more information, see [Removing databases from the system](https://www.ibm.com/support/knowledgecenter/SSXVXZ/com.ibm.i2.eia.go.live.doc/t_drop_databases.html).

To drop the database, you must ensure that there are no active connections to it.

### Stopping active connections to your SQL Server database
You can identify the active connections to the database by running the following command:
```
docker exec sqlserver /opt/mssql-tools/bin/sqlcmd -S localhost -U i2analyze -P Passw0rd -Q "EXEC SP_WHO2"
```
If the command returns no results, or there are no rows in the list with a *DBName* of `ISTORE`, there are no active connections to the Information Store.

Otherwise, make a note of all the values in the `SPID` column with a *DBName* of `ISTORE`.

The following is an example of how to stop an active connection with the SPID of `54`:
```
docker exec sqlserver /opt/mssql-tools/bin/sqlcmd -S localhost -U i2analyze -P Passw0rd -Q "KILL 54"
```
Any connections that you stop in this way are not in the list when you run the command to identify the active connections.

### Stopping active connections to your Db2 database
You can identify the active connections to the database by running the following command:
```
docker exec -u i2analyze -t db2 bash -c ". /home/db2inst1/sqllib/db2profile && db2 list applications"
```
If the command returns the `No data was returned by Database System Monitor` warning, or there are no rows in the list with a *DB Name* of `ISTORE`, there are no active connections to the Information Store.

Otherwise, make a note of all of the values in the `Appli. Handle` column with a *DB Name* of `ISTORE`.

The following is an example of how to stop two active connections with the application handles of `1414` and `1415`:
```
docker exec -u i2analyze -t db2 bash -c ". /home/db2inst1/sqllib/db2profile && db2 'force application (1414, 1415)'"
```
Any connections that you stop in this way are not in the list when you run the command to identify the active connections.

### Drop the database
After you ensure that there are no active connections to your database, you can drop the database by running the following command:
In SQL Server:
```
docker exec -u i2analyze -it admin_client /opt/IBM/i2analyze/toolkit/scripts/setup -t dropDatabases --hostname admin_client.eianet
```
In Db2:
```
docker exec -u i2analyze -it admin_client bash -c ". /home/db2inst1/sqllib/db2profile && /opt/IBM/i2analyze/toolkit/scripts/setup -t dropDatabases --hostname admin_client.eianet"
```
The `ISTORE` database is removed.

After you drop the Information Store database, you must remove the `dsid.infostore.properties` file from the Liberty server. The `dsid.infostore.properties` file contains the identifier for the Information Store that is used by i2 Analyze and Analyst's Notebook Premium.

To remove the file, run the following command:
```
docker exec -u i2analyze -t liberty rm /opt/IBM/i2analyze/toolkit/configuration/environment/dsid/dsid.infostore.properties
```

### Recreating the database
Before you can restart i2 Analyze, you must recreate the database.

To create the database, run the following command:
In SQL Server:
```
docker exec -u i2analyze -t admin_client /opt/IBM/i2analyze/toolkit/scripts/setup -t createDatabases
```
In Db2:
```
docker exec -u i2analyze -t admin_client bash -c ". /home/db2inst1/sqllib/db2profile && /opt/IBM/i2analyze/toolkit/scripts/setup -t createDatabases"
```

You must start Liberty:
```
docker exec -u i2analyze liberty /opt/IBM/i2analyze/toolkit/scripts/setup -t startLiberty
```
The console output from the `startLiberty` task is output directly to the console.

Liberty is now started and you can connect to i2 Analyze.

## Testing the deployment
Connect to i2 Analyze and search for data. If you perform a wildcard search for `*`, all of the data in your system is returned. After you remove the database from the system, this search returns no results.
