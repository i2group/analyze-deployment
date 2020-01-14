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

FROM mcr.microsoft.com/mssql-tools

LABEL maintainer="IBM i2"
LABEL version="2.1.1"

#Install the prerequisites.
RUN dpkg --add-architecture i386 && \
  apt-get update && \
  apt-get install -y \
    nano \
    bsdtar

RUN groupadd i2analyze
RUN useradd -m -g i2analyze i2analyze
#Create a group for securing the keys
RUN groupadd keys && usermod -a -G keys i2analyze


#Add the startupExt file for future startup commands
COPY --chown=i2analyze:i2analyze --from=ubuntu_toolkit_image /opt/IBM/startupExt /opt/IBM/startupExt

#Copy utils
COPY --chown=i2analyze:i2analyze --from=ubuntu_toolkit_image /opt/IBM/utils /opt/IBM/utils

#Change the user that runs Microsoft SQL Tools commands.
USER i2analyze:i2analyze

#Copy the example data to ingest.
COPY --chown=i2analyze:i2analyze example /opt/IBM/i2analyze/example

#Copy example ingestion script.
COPY --chown=i2analyze:i2analyze ingestExampleData /opt/IBM/i2analyze/ingestExampleData

#Add Microsoft SQL tools to the PATH.
ENV PATH=$PATH:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/mssql-tools/bin

ENTRYPOINT tail -f /dev/null
