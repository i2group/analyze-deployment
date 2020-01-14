# Creating a Solr collection using the `createSolrCollection` script file
Your `createSolrCollection` script in the `toolkit\configuration\environment\opal-server\main_index` directory must contain a `CREATE` call to the Solr Collections API.

## Before you begin
You must specify that you are using the `createSolrCollection` script to configure Solr. For more information, see [Choosing the method for configuring Solr](configure_solr_method.md).

## `CREATE` REST call
To create a collection, use the `CREATE` REST call in the `createSolrCollection` file. For more information about the `CREATE` REST call, and extra parameters that you can use, see [CREATE: Create a Collection](https://lucene.apache.org/solr/guide/6_6/collections-api.html#CollectionsAPI-create).

To create a collection, open the `createSolrCollection` script in a text editor.

The existing script might contain a `CREATE` call that is similar to the following example:
```
curl ?CERTIFICATE_PLACEHOLDER? ?CREDENTIALS_PLACEHOLDER? "?SCHEME_PLACEHOLDER?://solr:8983/solr/admin/collections?action=CREATE&name=main_index&collection.configName=main_index&numShards=4&maxShardsPerNode=4&replicationFactor=1"
```
The `?CERTIFICATE_PLACEHOLDER?, ?CREDENTIALS_PLACEHOLDER?, ?SCHEME_PLACEHOLDER?` variables are resolved by the toolkit when the script is run.

This example of a `CREATE` call creates a collection that has the following attributes:

- Named `main_index`
- A configuration named `main_index` in ZooKeeper
- Four shards
- A maximum of four shards per node
- One replica of each shard

## Recreating the collection
After you change the `createSolrCollection` script, you can recreate the Solr collection by completing the following steps.

To stop Liberty, run the following command:
```
docker exec -u i2analyze liberty /opt/IBM/i2analyze/toolkit/scripts/setup -t stopLiberty
```
The output from the `stopLiberty` task is output directly to the console.

To remove the current Solr collection, run the following command:
```
docker exec -it -u i2analyze admin_client /opt/IBM/i2analyze/toolkit/scripts/setup -t deleteSolrCollections --all --hostname admin_client
```
To create the Solr collection with the modified configuration, run the following command:
```
docker exec -t -u i2analyze admin_client /opt/IBM/i2analyze/toolkit/scripts/setup -t createSolrCollections --all --hostname admin_client
```
To clear the search index, run the following command:
```
docker exec -u i2analyze -it admin_client /opt/IBM/i2analyze/toolkit/scripts/setup -t clearSearchIndex --all --hostname admin_client
```
To restart Liberty, run the following command:
```
docker exec -u i2analyze liberty /opt/IBM/i2analyze/toolkit/scripts/setup -t startLiberty
```
The console output from the `startLiberty` task is output directly to the console.
Liberty is now started and you can connect to i2 Analyze.

## Modifying a collection
If you change the configuration of your Solr collection on a live deployment, you must replicate the changes in your `createSolrCollection` script. This ensures that if your Solr collection is recreated, it aligns with your configuration changes.

For example, if you add two shards to your live collection, you must increase the number of shards in the collection definition by 2.

For information about changing the Solr collection configuration on a live deployment, see [Adding another Solr server and Solr node](configure_solr_add_node.md), [Adding Solr shards to your deployment](configure_solr_add_shard.md), and [Adding Solr replicas to your deployment](configure_solr_add_replica.md).

>Note: If you add Solr nodes to your deployment after the Solr Collection is created, your `CREATE` call might distribute your original shards and replicas on different nodes. You must inspect your `createSolrCollection` script and ensure that it works if your Solr collection is created with the new nodes present from the start.
