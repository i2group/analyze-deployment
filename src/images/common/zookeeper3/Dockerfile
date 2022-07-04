# i2, i2 Group, the i2 Group logo, and i2group.com are trademarks of N.Harris Computer Corporation.
# © N.Harris Computer Corporation (2022)
#
# SPDX short identifier: MIT

FROM ubuntu_toolkit_image

#The host name of the Docker container.
ARG hostname=zookeeper3.eianet
ENV hostname $hostname

#The custom configuration overrides the base configuration in the ubuntu_toolkit_image.
COPY --chown=i2analyze:i2analyze configuration ${toolkitDir}/configuration

#Change the user that runs commands.
USER i2analyze:i2analyze

#Install ZooKeeper.
RUN /opt/i2/i2analyze/toolkit/scripts/setup -t installZookeeper

#Create the ZooKeeper host and the configuration for the ZooKeeper hosts on this server.
RUN /opt/i2/i2analyze/toolkit/scripts/setup -t createZkHosts --hostname ${hostname}

RUN echo "/opt/i2/i2analyze/toolkit/scripts/setup -t startZkHosts --hostname ${hostname} || echo \"Error stating Zookeeper host in ${hostname}\"" >> /opt/i2/startupExt

#Start ZooKeeper and upload the Solr configuration to ZooKeeper.
ENTRYPOINT /opt/i2/startupExt && tail -f /dev/null
