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

FROM db2_installer_image

ENV installation_media_Dir /opt/IBM/installation_media

#Copy and extract the ssl extensions directory to the correct location.
COPY /installation_media ${installation_media_Dir}
RUN bsdtar -xzpf ${installation_media_Dir}/DB2_SF_SSLF.tar.gz -C /opt/IBM/ \
    && rm -f ${installation_media_Dir}/DB2_SF_SSLF.tar.gz \
    && ls /opt/IBM

RUN apt-get update \
    && apt-get install -y alien \
    && alien -i -c /opt/IBM/gskit/linuxamd64/gskcrypt64-8.0.50.86.linux.x86_64.rpm \
    && alien -i -c /opt/IBM/gskit/linuxamd64/gskssl64-8.0.50.86.linux.x86_64.rpm

#Copy the db2server.rsp file to the correct location.
COPY db2client.rsp /opt/IBM/db2client.rsp

#Copy the installdb2 file to the correct location.
COPY installdb2 /opt/IBM/installdb
RUN chmod +x /opt/IBM/installdb

#Install DB2.
RUN /opt/IBM/installdb
