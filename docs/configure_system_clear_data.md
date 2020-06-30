# Clearing data from the system
During development, it is common to need to clear data from the i2 data stores.

## Before you begin
This process can permanently remove data from your system, ensure that no data is in the system that you want to keep.

For information about making a backup of your deployment, see [Backing up a deployment](https://www.ibm.com/support/knowledgecenter/SSXVXZ/com.ibm.i2.eia.go.live.doc/c_back_up_and_recovery.html).

## Stopping Liberty
Run the following command on the Liberty server to stop Liberty:
```
docker exec -u i2analyze liberty /opt/IBM/i2analyze/toolkit/scripts/setup -t stopLiberty
```
The console output from the `stopLiberty` task is output directly to the console.

## Clearing data from the system
To remove data from both the search index and the database, you can use the `clearData` toolkit task. For more information, see [Clearing data from the system](https://www.ibm.com/support/knowledgecenter/en/SSXVXZ/com.ibm.i2.eia.go.live.doc/t_clearing_data.html).

To clear the data, you can run the command from the Admin client or Liberty server. In the distributed deployment example, the `admin_client` container is used to run the command. The `admin_client` container includes the i2 Analyze toolkit and a database management client installation. You must run commands that modify the database and Solr and ZooKeeper from this container.

To clear the data, run the following command:
```
docker exec -u i2analyze -it admin_client /opt/IBM/i2analyze/toolkit/scripts/setup -t clearData --hostname admin_client.eianet
```
The database is now clear of data and the search index is now empty.

The database still exists with the structure from the schema. If you want to make destructive schema changes, follow the instructions in [Resetting the system](configure_system_reset.md).

## Restarting your system
To restart Liberty, run the following command:
```
docker exec -u i2analyze liberty /opt/IBM/i2analyze/toolkit/scripts/setup -t startLiberty
```
The console output from the `startLiberty` task is output directly to the console.

Liberty is now started and you can connect to i2 Analyze.

## Testing the deployment
Connect to i2 Analyze and search for data. If you perform a wildcard search for `*`, all of the data in your system is returned. After you run `clearData`, this search returns no results.
