# i2, i2 Group, the i2 Group logo, and i2group.com are trademarks of N.Harris Computer Corporation.
# © N.Harris Computer Corporation (2022-2023)
#
# SPDX short identifier: MIT

FROM db2_installer_image

#Copy the db2server.rsp file to the correct location.
COPY db2server.rsp /opt/IBM/db2server.rsp

#Copy the installdb2 file to the correct location.
COPY installdb2 /opt/IBM/installdb
RUN chmod +x /opt/IBM/installdb

#Install DB2.
RUN /opt/IBM/installdb

COPY --chown=db2inst1:db2iadm1 db2nodes.cfg /home/db2inst1/sqllib/db2nodes.cfg

#Create a group for securing the keys
RUN usermod -a -G keys db2inst1

RUN echo ". /home/db2inst1/sqllib/db2profile && db2start || echo \"Error starting DB2\"" >> /opt/i2/startupExt

USER db2inst1:db2iadm1

RUN /home/db2inst1/sqllib/adm/db2licm -a /opt/IBM/adv_vpc/db2/license/db2adv_vpc.lic

EXPOSE 50000 50001

ENTRYPOINT /opt/i2/startupExt && tail -f /dev/null
