# i2, i2 Group, the i2 Group logo, and i2group.com are trademarks of N.Harris Computer Corporation.
# © N.Harris Computer Corporation (2022)
#
# SPDX short identifier: MIT

FROM base_client_image

RUN apt-get install -y \
    openssh-client

#The custom configuration overrides the base configuration in the ubuntu_toolkit_image.
COPY --chown=i2analyze:i2analyze configuration ${toolkitDir}/configuration

#Change the user that runs DB2 commands.
USER i2analyze:db2iusr1

#Catalog the remote DB2 node to enable deletion by rule.
RUN . /home/db2inst1/sqllib/db2profile && ${toolkitDir}/scripts/setup -t catalogRemoteDB2Nodes
RUN . /home/db2inst1/sqllib/db2profile && ${toolkitDir}/scripts/setup -t catalogDB2Databases

USER i2analyze:i2analyze

#Install the dependencies.
RUN ${toolkitDir}/scripts/setup -t installLiberty

#Deploy Liberty with the i2 Analyze application.
RUN ${toolkitDir}/scripts/setup -t deployLiberty

#Create an example user registry in Liberty.
RUN ${toolkitDir}/scripts/setup -t ensureExampleUserRegistry
COPY --chown=i2analyze:i2analyze user.registry.xml /opt/i2/i2analyze/deploy/wlp/usr/shared/config/

RUN echo "export JAVA_HOME=/opt/i2/i2analyze/deploy/java && /opt/i2/i2analyze/toolkit/scripts/setup -t startLiberty || echo \"Error starting Liberty\"" >> /opt/i2/startupExt

EXPOSE 9082 9445

#Start the Liberty server that hosts i2 Analyze.
ENTRYPOINT /opt/i2/startupExt && tail -f /dev/null
