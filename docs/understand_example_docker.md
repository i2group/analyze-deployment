# Understanding Docker in the distributed deployment example
The distributed deployment example demonstrates how to build a distributed deployment of i2 Analyze on multiple servers. To avoid the need for multiple physical servers, Docker is used to simulate the servers.

## Docker
Docker is used to build and maintain Docker images and containers.
For more information about Docker, see [Docker overview](https://docs.docker.com/get-started/overview/#the-docker-platform).

### Docker containers and images
A Docker container represents a physical server in a non-Docker environment. In the distributed deployment example i2 Analyze is deployed across the Docker containers, this represents the deployment of i2 Analyze across physical servers in a non-Docker environment.

In the example, there are Docker images and containers for the servers that host the components of i2 Analyze. Additionally, the Ubuntu toolkit image has the files that make up Ubuntu with the i2 Analyze toolkit installed and the base configuration image contains the i2 Analyze configuration files that are not modified as part of this example. In a non-Docker environment, this might be a server that you are not using as part of the deployment.

To simulate starting a server, run a container from its corresponding image.

For more information about Docker containers and images, see [Docker objects](https://docs.docker.com/get-started/overview/#docker-objects).

### Dockerfiles
In the distributed deployment example, `Dockerfiles` are used to define what is installed onto the file system and what is run on startup of the server.

For more information about `Dockerfile` definitions, see [Dockerfile format](https://docs.docker.com/engine/reference/builder/#format).

The `Dockerfiles` are in each `src/images/<container_name>` directory. You can use a text editor to inspect the `Dockerfiles`. The `Dockerfiles` contain the commands that are used to build the Docker image.

Some commands in the `Dockerfiles` are specific to Docker, and required for the distributed deployment example to work in a Docker environment. However, all of the actions or commands that a system implementer must complete in a non-Docker environment are surfaced here. To identify the commands a system implementer requires, you must understand the `Dockerfiles`.

The following instructions are used in commands in the `Dockerfiles`:

- The `COPY` instruction copies files or directories to the file system of the container.

  To replicate the `COPY` instruction in a non-Docker environment, copy the files or directories to same location on the physical server that the container represents.

- The `RUN` instruction runs commands that add files into the image. It is used to run installers, toolkit commands, and other commands that add files into the image.  

  To replicate the `RUN` instruction in a non-Docker environment, run the same commands in the same order on the physical server that the container represents.

- The `ENTRYPOINT` instruction represents commands that are run at server startup.

  To replicate the `ENTRYPOINT` instruction in a non-Docker environment, run the same command on the physical server that the container represents.

  > The `ENTRYPOINT` also has a command that never completes so that the Docker container continues to run. For example, `&& tail -f /dev/null`. This applies to the Docker environment only.

- The `EXPOSE` instruction lists the ports that the container listens on.  
    This is used so that the host machine can access these ports on the Docker network that the containers use.

- The `ENV` instruction sets the host name of the Docker container. The host names are used in the `topology.xml`.


Extra instructions in the `Dockerfiles`:

- The `FROM` and `MAINTAINER` instructions complete Docker specific configuration, and do not need to be replicated in a non-Docker environment.
