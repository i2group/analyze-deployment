# i2, i2 Group, the i2 Group logo, and i2group.com are trademarks of N.Harris Computer Corporation.
# © N.Harris Computer Corporation (2022-2023)
#
# SPDX short identifier: MIT

FROM ubuntu_toolkit_image

#The host name of the Docker container.
ARG hostname=solr2.eianet
ENV hostname $hostname

#The custom configuration overrides the base configuration in the ubuntu_toolkit_image.
COPY --chown=i2analyze:i2analyze configuration ${toolkitDir}/configuration

#Change the user that runs commands.
USER i2analyze:i2analyze

#Install Solr.
RUN /opt/i2/i2analyze/toolkit/scripts/setup -t installSolr

#Create the Solr node and the configuration.
RUN /opt/i2/i2analyze/toolkit/scripts/setup -t createSolrNodes --hostname ${hostname}

RUN echo "/opt/i2/i2analyze/toolkit/scripts/setup -t startSolrNodes --hostname ${hostname} || echo \"Error stating Solr node in ${hostname}\"" >> /opt/i2/startupExt

EXPOSE 8984

#Start the Solr node.
ENTRYPOINT /opt/i2/startupExt && tail -f /dev/null
