# i2, i2 Group, the i2 Group logo, and i2group.com are trademarks of N.Harris Computer Corporation.
# © N.Harris Computer Corporation (2022-2023)
#
# SPDX short identifier: MIT

FROM base_client_image

RUN apt-get install -y \
    openssh-client

#The custom configuration overrides the base configuration in the ubuntu_toolkit_image.
COPY --chown=i2analyze:i2analyze configuration ${toolkitDir}/configuration

USER i2analyze:i2analyze

#Install the dependencies.
RUN ${toolkitDir}/scripts/setup -t installZookeeper
RUN ${toolkitDir}/scripts/setup -t installSolr

#Change the user that runs DB2 commands.
USER i2analyze:db2iusr1

#Catalog the remote DB2 node to enable running commands on the remote instance of DB2.
RUN . /home/db2inst1/sqllib/db2profile && ${toolkitDir}/scripts/setup -t catalogRemoteDB2Nodes

RUN echo "echo \"Admin client: Started\"" >> /opt/i2/startupExt

ENTRYPOINT /opt/i2/startupExt && tail -f dev/null
