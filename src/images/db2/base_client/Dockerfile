# i2, i2 Group, the i2 Group logo, and i2group.com are trademarks of N.Harris Computer Corporation.
# © N.Harris Computer Corporation (2022)
#
# SPDX short identifier: MIT

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
