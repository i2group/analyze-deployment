# i2, i2 Group, the i2 Group logo, and i2group.com are trademarks of N.Harris Computer Corporation.
# © N.Harris Computer Corporation (2022-2023)
#
# SPDX short identifier: MIT

FROM ubuntu_toolkit_image

#Create OS groups referenced by the db2 installer response file
RUN groupadd db2ictl1
RUN groupadd db2iusr1

#Add i2 analyze user to db2 groups
RUN usermod -g db2iusr1 i2analyze && usermod -a -G db2ictl1 i2analyze

ENV installation_media_Dir /opt/IBM/installation_media

#Copy the adv_vpc directory to the correct location.
COPY adv_vpc /opt/IBM/adv_vpc

#Copy and extract the server_dec directory to the correct location.
COPY installation_media ${installation_media_Dir}

RUN bsdtar -xzpf ${installation_media_Dir}/DB2_AWSE_REST_Svr.tar.gz -C /opt/IBM/ \
    && rm -f ${installation_media_Dir}/DB2_AWSE_REST_Svr.tar.gz \
    && ls /opt/IBM

#Add DB2 to the PATH.
ENV PATH=$PATH:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/home/db2inst1/sqllib/bin:/home/db2inst1/sqllib/adm:/home/db2inst1/sqllib/misc

#Add db2profile to the i2analyze user .profile
RUN echo "" >> /home/i2analyze/.profile
RUN echo ". /home/db2inst1/sqllib/db2profile" >> /home/i2analyze/.profile
