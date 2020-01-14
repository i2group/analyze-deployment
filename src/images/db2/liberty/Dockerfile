#/********************************************************************************
# * (C) Copyright IBM Corporation 2018, 2019.
# *
# * This program and the accompanying materials are made available under the
# * terms of the Eclipse Public License 2.0 which is available at
# * http://www.eclipse.org/legal/epl-2.0.
# *
# * SPDX-License-Identifier: EPL-2.0
# *
# ********************************************************************************/

FROM base_client_image

RUN apt-get install -y \
    openssh-client

#The custom configuration overrides the base configuration in the ubuntu_toolkit_image.
COPY --chown=i2analyze:i2analyze configuration ${toolkitDir}/configuration

#Change the user that runs DB2 commands.
USER i2analyze:db2iusr1

#Catalog the remote DB2 node to enable deletion by rule.
RUN ${toolkitDir}/scripts/setup -t catalogRemoteDB2Nodes
RUN ${toolkitDir}/scripts/setup -t catalogDB2Databases

USER i2analyze:i2analyze

#Install the dependencies.
RUN ${toolkitDir}/scripts/setup -t installLiberty

#Deploy Liberty with the i2 Analyze application.
RUN ${toolkitDir}/scripts/setup -t deployLiberty

#Create an example user registry in Liberty.
RUN ${toolkitDir}/scripts/setup -t ensureExampleUserRegistry
COPY --chown=i2analyze:i2analyze user.registry.xml /opt/IBM/i2analyze/deploy/wlp/usr/shared/config/

RUN echo "export JAVA_HOME=/opt/IBM/i2analyze/deploy/java && /opt/IBM/i2analyze/toolkit/scripts/setup -t startLiberty || echo \"Error starting Liberty\"" >> /opt/IBM/startupExt

EXPOSE 9082 9445

#Start the Liberty server that hosts i2 Analyze.
ENTRYPOINT /opt/IBM/startupExt && tail -f /dev/null
