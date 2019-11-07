# Distributed deployment of i2 Analyze example
An example environment is provided to demonstrate how to build a distributed deployment of i2 Analyze on multiple servers. The following documentation is provided so that you can understand, deploy, and configure the distributed deployment example.

>**Important**: The distributed deployment example uses a Docker environment to demonstrate a distributed deployment of i2 Analyze. The Docker environment is not designed to be used on customer sites for test or production systems. The objective of the distributed deployment example on Docker is to give you an understanding of how a distributed deployment of i2 Analyze is deployed, so that you can replicate the deployment on physical servers.

This information is intended for users who want to learn how to deploy i2 Analyze distributed across multiple servers. Readers must be familiar with i2 Analyze and the prerequisite components.

The documentation for understanding, deploying, and configuring the distributed deployment example is divided into the following sections:

- **Understand** the distributed deployment example:  
  - [Understanding the example](understand_example.md)
  - [Understanding Docker in the distributed deployment example](understand_example_docker.md)


- **Deploy** the distributed deployment example:  
  - [Quick start](deploy_quick_start.md)
  - [Deploying the distributed deployment example manually for SQL Server](deploy_walk_through_sqlserver.md)
  - [Deploying the distributed deployment example manually for Db2](deploy_walk_through_db2.md)
  - [Deploying the distributed deployment example with IBM HTTP Server](deploy_walk_through_http.md)
  - [Keystores and certificates for components of i2 Analyze](securing_certificates.md)
  - [Deploying the distributed deployment example with security](securing_ssl.md)
  - [Configuring ZooKeeper and i2 Analyze to use an SSH tunnel](configure_zookeeper_tunneling.md)
  - [Deploying i2 Analyze with i2 Connect](deploy_i2_connect.md)
  - [Upgrading a distributed deployment to version 4.3.0 of i2 Analyze](upgrade_walk_through.md)
  - [Cleaning your environment](deploy_clean_environment.md)


- **Configure** the deployment:  
  - [Updating the schema](configure_change_schema.md)
  - [Updating the security schema](configure_change_security_schema.md)
  - [Changing the search results filtering](configure_search_facets.md)
  - [Changing Visual Query conditions](configure_search_vq.md)
  - [Clearing data from the system](configure_system_clear_data.md)
  - [Resetting the system](configure_system_reset.md)
  - [Configuring Liberty](configure_liberty.md)
  - [Ingesting data remotely](deploy_etl_client.md)
  - [Choosing the method for configuring Solr](configure_solr_method.md)
    - [Creating a Solr collection using the `createSolrCollection` script](configure_solr_collection.md)
    - [Adding Solr replicas to your deployment](configure_solr_add_replica.md)
    - [Adding Solr shards to your deployment](configure_solr_add_shard.md)
    - [Adding another Solr server and Solr node](configure_solr_add_node.md)
    - [Changing the memory allocation for a Solr node](configure_solr_change_node_memory.md)
  - [Adding other ZooKeeper servers](configure_zookeeper_add_hosts.md)
