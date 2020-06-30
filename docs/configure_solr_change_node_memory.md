# Changing the memory allocation for a Solr node
After you deploy your system, you might need to change the maximum Java virtual machine (JVM) memory allocation allowance for your Solr nodes.
For more information about configuring the JVM memory allocation, see [JVM Settings](https://lucene.apache.org/solr/guide/6_6/jvm-settings.html).

## Modifying the `topology.xml`
Modify the `topology.xml` in the `src/configuration/environment` directory.  
For the Solr node that you want to change the memory allocation of, change the value of the  `memory` attribute of the `solr-node` element.

For example, the memory allocation for `node1`, which runs on the `solr` container, is changed to `4g`:
```
<solr-nodes>
  <solr-node memory="4g" data-dir="/opt/IBM/i2analyze/data/solr" host-name="solr.eianet" id="node1" port-number="8983"/>
  <solr-node memory="512m" data-dir="/opt/IBM/i2analyze/data/solr" host-name="solr2.eianet" id="node2" port-number="8984"/>
</solr-nodes>
```

## Copying the configuration
The configuration was modified for the Solr node that runs on the `solr` server. You must copy the new configuration to the Solr server.

In a Docker environment, use the Docker `cp` command to copy, and overwrite, your configuration to the running `solr` container. In the `src` directory, run the following command:
```
docker cp ./configuration solr:/opt/IBM/i2analyze/toolkit/
```
The new configuration is now on the `solr` container.

When the directory is copied, the owner of the directory, and all files within it, is changed. The user that runs the deployment script must be able to write to files within the `configuration` directory. To change the ownership of the directory and the files, run the following command:
```
docker exec -u root solr chown -R i2analyze:i2analyze /opt/IBM/i2analyze/toolkit/configuration
```

In a non-Docker environment, copy the modified `topology.xml` file to the same location in your i2 Analyze toolkit on the Solr server.

## Updating the Solr node
Restart the Solr node with the new configuration.
Restart the Solr node on the `solr` container by running the following command:
```
docker exec -u i2analyze -t solr /opt/IBM/i2analyze/toolkit/scripts/setup -t restartSolrNodes --hostname solr
```
The Solr node is restarted with the new JVM maximum memory allocation.

## Testing the deployment

You can use the Solr Web UI to inspect the Solr node that you modified to see the new memory allocation. To connect to the Solr Web UI of the Solr node on the `solr` container, go to: <http://localhost:8983/solr/#/>. The user name is `solradmin` and the password is the Solr password set in the `credentials.properties` file. 

On the right side of the dashboard, see that the **JVM-Memory** has a value of **4GB**.
