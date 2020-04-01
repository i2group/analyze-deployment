#/********************************************************************************
# * (C) Copyright IBM Corporation 2018, 2020.
# *
# * This program and the accompanying materials are made available under the
# * terms of the Eclipse Public License 2.0 which is available at
# * http://www.eclipse.org/legal/epl-2.0.
# *
# * SPDX-License-Identifier: EPL-2.0
# *
# ********************************************************************************/

FROM ubuntu_toolkit_image

RUN apt-get install -y \
    openssh-client

#The host name of the Docker container.
ARG hostname=solr
ENV hostname $hostname

#The custom configuration overrides the base configuration in the ubuntu_toolkit_image.
COPY --chown=i2analyze:i2analyze configuration ${toolkitDir}/configuration

#Change the user that runs commands.
USER i2analyze:i2analyze

#Install Solr.
RUN /opt/IBM/i2analyze/toolkit/scripts/setup -t installSolr

#Create the Solr node and the configuration.
RUN /opt/IBM/i2analyze/toolkit/scripts/setup -t createSolrNodes --hostname ${hostname}

RUN echo "/opt/IBM/i2analyze/toolkit/scripts/setup -t startSolrNodes --hostname ${hostname} || echo \"Error stating Solr node in ${hostname}\"" >> /opt/IBM/startupExt

EXPOSE 8983

#Start the Solr node.
ENTRYPOINT /opt/IBM/startupExt && tail -f /dev/null
