# Adding Solr shards to your deployment
You can modify the Solr configuration by using the *Solr Collections API*. After you change the Solr collection in a live deployment, replicate the changes in the definition of how the Solr collection is created.

## Overview
When you first deploy i2 Analyze, you should create a Solr collection that comprises enough shards to satisfy your future data requirements.

If your data requirements change, you can add more shards to your deployment.

## Adding a shard to the Solr collection definition
After you identify the number of shards that you require, add them to your Solr collection definition:
- If your Solr collection is configured by the `createSolrCollection` script, increase the number of shards for your collection in the `CREATE` call to the Solr Collections API.
- If your Solr collection is configured by the toolkit, increase the value of the `num-shards` attribute for your collection in the `topology.xml` file.

The next time that the Solr collection is created by the toolkit, it is created with the number of shards that you specify.

The following steps are only required when you want to add a shard to a live deployment.

---

## Adding a shard to a live collection
In the Solr collections that are created by i2 Analyze, the `compositeId` router is used, which means that you cannot add shards explicitly. To add a shard to an existing collection, you must split an existing one.

If you add a shard to a live collection, you must replicate the same changes to your Solr collection creation definition.

### Splitting a shard
To split `shard1` in the distributed deployment example, enter the following line into the URL field in a web browser:
```
http://localhost:8983/solr/admin/collections?action=SPLITSHARD&collection=main_index&shard=shard1
```
This sends a REST call to the Solr Collections API to split `shard1`.

For more information about the `SPLITSHARD` call, see [SPLITSHARD: Split a shard](https://lucene.apache.org/solr/guide/6_6/collections-api.html#CollectionsAPI-splitshard).

The process of splitting a shard creates two new shards from the original shard. When a shard is split, the names of the two new shards that are created are the name of the original shard that is suffixed with `_0` and `_1`.

The original shard becomes inactive as soon as the new shards and their replicas are up.

The replication factor of the original shard is maintained. If your shard had two replicas, when it is split each new shard also has two replicas.

>Note: The new shards are always placed on the same node as the parent shard.

### Deleting the inactive shard
You can remove the inactive `shard1` from the collection.

To delete the shard, enter the following line into the URL field in a web browser and press **Enter**:
```
http://localhost:8983/solr/admin/collections?action=DELETESHARD&shard=shard1&collection=main_index
```
This sends a REST call to the Solr Collections API to delete `shard1`.

For more information about the `DELETESHARD` call, see [DELETESHARD: Delete a shard](https://lucene.apache.org/solr/guide/6_6/collections-api.html#CollectionsAPI-deleteshard).

You can now either test or the deployment, or move the new shard to another Solr node.

---

## Moving a shard to another node
If you want to move one of the new split shards, you must create a replica of it on another node and then delete the original. To create the REST call to do this, you must know the collection name, the shard to replicate, and the node to add the replica to.

To identify the node name, navigate to the *Tree View* of SolrCLoud in the Solr Web UI on any of your running Solr servers.
For example:
```
http://localhost:8983/solr/#/~cloud?view=tree
```
Go to `/live_nodes` and choose the name of the node that you want to move your replica to. For example:
```
solr3.eianet:8985_solr
```
>Note: Only live Solr nodes are displayed.

To add a replica of the new `shard1_1` shard to the new Solr node 3, paste the following line into your browser:
```
http://localhost:8983/solr/admin/collections?action=ADDREPLICA&collection=main_index&shard=shard1_1&node=solr3.eianet:8985_solr
```
This sends a REST call to the Solr Collections API to create a replica of `shard1_1` on `solr3` that is on port 8985.

For more information about the `ADDREPLICA` call, see [ADDREPLICA: Add replicas](https://lucene.apache.org/solr/guide/6_6/collections-api.html#CollectionsAPI-addreplica).

### Deleting the original replica
To delete the original replica that was created when the shard was split, you must have the name of the replica to remove.
To get the replica name, go to the *Tree View* of SolrCLoud in the Solr Web UI.

For example:
```
http://localhost:8983/solr/#/~cloud?view=tree
```

Go to `/collections/main_index/state.json`.
This file describes the composition of your collection.
Identify the replica to delete by looking at the shard that the replica replicates, and the node that the replica is located.

In this example, the replica to remove is  `shards.shard1_1.replicas.core_node6`.

To delete this replica, paste the following line into your browser:
```
http://localhost:8983/solr/admin/collections?action=DELETEREPLICA&collection=main_index&shard=shard1_1&replica=core_node6
```
This sends a REST call to the Solr Collections API to delete the first replica of `shard1_1` that was on node `solr2`.

For more information about the `DELETEREPLICA` call, see [DELETEREPLICA: Delete a replica](https://lucene.apache.org/solr/guide/6_6/collections-api.html#CollectionsAPI-deletereplica).

---

## Testing the deployment
To test that the system continues to work, create and search for data by using Quick Search in Analyst's Notebook Premium.
