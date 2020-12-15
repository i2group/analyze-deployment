# Choosing the method for configuring Solr
A deployment of i2 Analyze uses Solr to manage the search index. i2 Analyze requires at least one Solr collection that consists of nodes, shards, and replicas.

The Solr configuration can be controlled through the `topology.xml` file, or through the `createSolrCollection` script. Regardless of how Solr is configured, the collection is created by i2 Analyze.

If the collection is configured through the `topology.xml` file, the modifications that you can complete are limited to those that are supported in the `topology.xml` file. If the collection is managed through the `createSolrCollection` script, you can complete all the modifications that are supported by the Solr Collections API.

The `createSolrCollection` script file contains REST calls to the Solr Collections API to configure the Solr collection.
The script uses `curl` commands to make the REST calls.
>Note: You must install `curl` on your path to use the `createSolrCollection` script as it is generated.


## Configure the Solr collection in the `topology.xml` file
By default, or when `toolkit-configured="true"` in the `solr-collection` element of the `topology.xml` file, the Solr collection is created by using the definitions in the `topology.xml` file.

For example, the `<solr-collection>` element is defined as follows:
```
<solr-collection toolkit-configured="true" num-replicas="1" id="main_index" max-shards-per-node="4" num-shards="4"/>
```

For more information about configuring the collection and the values that you can set in the topology file, see [ZooKeeper and Solr](https://www.ibm.com/support/knowledgecenter/SSXVTH_latest/com.ibm.i2.eia.go.live.doc/c_solr.html).

The Solr collection is created when the `createSolrCollections` toolkit task is run the first time. After, you can use the `clearSearchIndex` toolkit task. This task clears the search index, and then recreates the collection. When Liberty starts, the search index is recreated.


## Configure the Solr collection in the `createSolrCollection` script file
If you deployed the distributed deployment example, the `createSolrCollection` script is in the `toolkit\configuration\environment\opal-server\main_index` directory on the server that the `createSolrCollection` script was run. You can then change the topology file to `toolkit-configured="false"`.

>Note: If the script doesn't exist, run `setup -t createSolrCollections` toolkit task with `toolkit-configured="true"` in the `topology.xml` file.

If `toolkit-configured="false"` in the `topology.xml` file, the `createSolrCollection` script is used to configure the Solr collection.

For example, the `<solr-collection>` element is defined as follows:
```
<solr-collection toolkit-configured="false" num-replicas="1" id="main_index" max-shards-per-node="4" num-shards="4"/>
```

The script file contains the Solr collection configuration from the `topology.xml` file. You can then modify the Solr Collections API `CREATE` call in the script file. When i2 Analyze recreates the Solr collection, it uses the call in this file.

For more information about configuring the collection by using the script, see [Creating a Solr collection using the `createSolrCollection` script](configure_solr_collection.md).

### Managing changes to the `createSolrCollection` script file
The script file contains the definition of your Solr collection.

You must keep a copy of the `createSolrCollection`
in a source control system to ensure that the REST call required to make your Solr collection is maintained. You might need to use previous versions of this file when you move from a test to a production system, or when you make a configuration change that you later decide is incorrect.  
