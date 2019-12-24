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

RUN echo "db2start || echo \"Error starting DB2\"" >> /opt/IBM/startupExt

USER db2inst1:db2iadm1
RUN /home/db2inst1/sqllib/adm/db2licm -a /opt/IBM/awse_o/db2/license/db2awse_o.lic

EXPOSE 50000 50001

ENTRYPOINT /opt/IBM/startupExt && tail -f /dev/null
