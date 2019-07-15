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

USER i2analyze:i2analyze

#Install the dependencies.
RUN ${toolkitDir}/scripts/setup -t installZookeeper
RUN ${toolkitDir}/scripts/setup -t installSolr

#Change the user that runs DB2 commands.
USER i2analyze:db2iusr1

#Catalog the remote DB2 node to enable running commands on the remote instance of DB2.
RUN ${toolkitDir}/scripts/setup -t catalogRemoteDB2Nodes

RUN echo "echo \"Admin client: Started\"" >> /opt/IBM/startupExt

ENTRYPOINT /opt/IBM/startupExt && tail -f dev/null
