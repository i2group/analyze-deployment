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

FROM mcr.microsoft.com/mssql/server:2017-latest

#Install the prerequisites.
RUN dpkg --add-architecture i386 && \
  apt-get update && \
  apt-get install -y \
    nano \
    bsdtar \
    openssh-client

#Copy utils
COPY --from=ubuntu_toolkit_image /opt/IBM/utils /opt/IBM/utils

#Create a group for securing the keys
RUN groupadd keys

#Copy sql server config 
COPY mssql.conf /var/opt/mssql/
