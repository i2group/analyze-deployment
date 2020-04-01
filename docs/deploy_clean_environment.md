# Cleaning your environment
Docker containers, images, and networks must have unique names. To recreate the distributed deployment example, or modify images and containers, you must remove the existing ones before you can build and run new ones.

## `clean` script
You can run the `src/scripts/clean` file to clean your environment. The `clean` file removes all of the example containers, images, and the network from your environment.

The following sections describe in detail how to clean your environment manually.

## Removing containers
To remove containers, run the Docker `rm` command and specify the name of the containers to remove. For example, run the following command:
```
docker rm -f container_name
```
To remove all of the containers that are used in the distributed deployment example, run the following command:
```
docker rm -f zookeeper solr solr2 db2 sqlserver liberty admin_client etl_client ihs ca zookeeper2 zookeeper3 solr3 connector
```

Attempting to remove containers that do not exist errors but does not stop the rest of the existing containers from being removed.

You can now restart any of the containers that were removed.

## Removing images
After all of the containers that are running the images are removed, you can remove the images.

To remove images, run the Docker `rmi` command and specify the names of the images to remove. For example:
```
docker rmi -f image_name
```

To remove the images that are used in the distributed deployment example, run the following commands:
```
docker rmi -f zookeeper_image solr_image zookeeper2_image solr_image zookeeper3_image solr_image solr2_image ihs_image liberty_db2_image liberty_sqlserver_image etl_client_db2_image etl_client_sqlserver_image
docker rmi -f ca_image connector_image db2_installer_image db2_image admin_client_db2_image admin_client_sqlserver_image base_client_image
docker rmi -f ubuntu_toolkit_image
```
>Note: If the image that you want to remove is used to derive other images, you must remove all of the derived images before you can remove the image.

If you try to remove an image that does not exist, the command results in an error but other images are still removed.

After you remove an image, you can rebuild it.

If you want to also remove the image dependencies, you can run:
```
docker rmi -f ubuntu ibmcom/ibm-http-server
```

## Removing the network
After all of the containers are removed, you can remove the network.

To remove the network, run the docker `network` command with the `rm` flag and specify the network name to remove. For example, run the following command:
```
docker network rm network_name
```

To remote the network that is used in the distributed deployment example, run the following command:
```
docker network rm eianet
```

The `eianet` network is removed.
