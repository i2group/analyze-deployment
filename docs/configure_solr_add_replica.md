# Adding Solr replicas to your deployment
If a logical shard in the Solr collection becomes unusable, then the search index also becomes unusable. To increase the resilience of the search index, replicas of shards can be created that are distinct from their original shard. These replicas can be located on different physical servers.
A replica acts as a physical copy of a shard in a SolrCloud Collection.

After you change the Solr collection in a live deployment, replicate the changes in the definition of how the Solr collection is created.

## Adding replicas to the Solr collection definition
After you identify how many replicas you require, add them to your Solr collection definition:
- If your Solr collection is configured by the `createSolrCollection` script, increase the replication factor for your collection in the `CREATE` call to the Solr Collections API.
- If your Solr collection is configured by the toolkit, increase the value of the `num-replicas` attribute for your collection in the `topology.xml` file.

For example, if you want to have two replicas of each shard, increase the `replicationFactor` or `num-replicas` value to 2.

The next time that the Solr collection is created by the toolkit, it is created with the replication factor that you specified in the `topology.xml` file or the `createSolrCollection` script.

You only need to complete the following steps when you are adding replicas to a live system. If you do add replicas to the live system, ensure that you update the collection definition.

---

## Adding replicas to a live collection
Add a replica of each shard in the Solr collection.
To add a replica of each shard in the distributed deployment example, enter the following lines into the URL field in a web browser:
```
http://localhost:8983/solr/admin/collections?action=ADDREPLICA&collection=main_index&shard=shard1&node=solr2.eianet:8984_solr
```
```
http://localhost:8983/solr/admin/collections?action=ADDREPLICA&collection=main_index&shard=shard2&node=solr.eianet:8983_solr
```
```
http://localhost:8983/solr/admin/collections?action=ADDREPLICA&collection=main_index&shard=shard3&node=solr2.eianet:8984_solr
```
```
http://localhost:8983/solr/admin/collections?action=ADDREPLICA&collection=main_index&shard=shard4&node=solr.eianet:8983_solr
```
These send a REST call to the Solr Collections API to add a replica of a specific shard on a specific node. Each of the shards now has an extra replica, on a different node to the original shard.

For more information about the `ADDREPLICA` call, see [ADDREPLICA: Add replicas](https://lucene.apache.org/solr/guide/6_6/collections-api.html#CollectionsAPI-addreplica).

To prepare the REST calls, you must know the collection name, the shard to replicate, and the node to add the replica to.

To identify the node name, go to the *Tree View* of SolrCloud in the Solr Web UI on any of your running Solr servers. For example:
```
http://localhost:8983/solr/#/~cloud?view=tree
```

Go to `/live_nodes`, and choose the name of the node that you want to move your replica to. For example:
```
solr2.eianet:8984_solr
```

>Note: Only live Solr nodes are displayed.

You can use this method to choose the number of replicas to create, and where they are located.
To show the *Graph View* that shows replicas in the Solr Web UI, connect to the Solr Web UI by using the following URL: <http://localhost:8983/solr/#/~cloud>. The user name is `solradmin` and the password is the Solr password set in the `credentials.properties` file.

>Important: After you change the Solr collection in a live deployment, replicate the changes in the definition of how the Solr collection is created.

## Testing the replicas
To test that the replicas are added successfully, and that your system has a level of redundancy, stop one of the Solr nodes.

To stop the Solr node on the `solr` container, run the following command:
```
docker exec -u i2analyze -t solr /opt/IBM/i2analyze/toolkit/scripts/setup -t stopSolrNodes --hostname solr.eianet  
```
In the Solr Web UI *Tree View* on the `solr2` container, all the shards are still up and active. The newly created replicas are now the leaders for the shards.

If you do a Quick Search by using Analyst's Notebook Premium, any data that was in the Information Store is still available.

You can start the `solr` container, and the Solr node starts again.

To start the `solr` container, run the following command:
```
docker exec -u i2analyze -t solr /opt/IBM/i2analyze/toolkit/scripts/setup -t startSolrNodes --hostname solr.eianet  
```
In the Solr Web UI *Tree View*, you can see that the Solr node and shards are active.
