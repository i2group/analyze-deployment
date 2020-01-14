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

FROM ubuntu_toolkit_image

#Create OS groups referenced by the db2 installer response file
RUN groupadd db2ictl1
RUN groupadd db2iusr1

#Add i2 analyze user to db2 groups
RUN usermod -g db2iusr1 i2analyze && usermod -a -G db2ictl1 i2analyze

ENV installation_media_Dir /opt/IBM/installation_media

#Copy the awse_o directory to the correct location.
COPY awse_o /opt/IBM/awse_o

#Copy and extract the server_awse_o directory to the correct location.
COPY installation_media ${installation_media_Dir}

RUN bsdtar -xzpf ${installation_media_Dir}/DB2_AWSE_REST_Svr.tar.gz -C /opt/IBM/ \
    && rm -f ${installation_media_Dir}/DB2_AWSE_REST_Svr.tar.gz \
    && ls /opt/IBM

#Add DB2 to the PATH.
ENV PATH=$PATH:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/home/db2inst1/sqllib/bin:/home/db2inst1/sqllib/adm:/home/db2inst1/sqllib/misc
