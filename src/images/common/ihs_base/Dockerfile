#/********************************************************************************
# * (C) Copyright IBM Corporation 2018, 2021.
# *
# * This program and the accompanying materials are made available under the
# * terms of the Eclipse Public License 2.0 which is available at
# * http://www.eclipse.org/legal/epl-2.0.
# *
# * SPDX-License-Identifier: EPL-2.0
# *
# ********************************************************************************/
FROM ubuntu:18.04

LABEL maintainer="IBM i2"
LABEL version="2.5.0"

ARG IHS_ARCHIVE_FILE

#Install the prerequisites.
RUN dpkg --add-architecture i386 && \
  apt-get update && \
  apt-get install -y unzip

COPY $IHS_ARCHIVE_FILE /tmp/

RUN unzip -q -d /opt/IBM /tmp/$IHS_ARCHIVE_FILE
RUN mv /opt/IBM/IHS /opt/IBM/HTTPServer
RUN ln -s /opt/IBM/HTTPServer/conf /conf
RUN ln -s /opt/IBM/HTTPServer/htdocs /htdocs
RUN ln -s /opt/IBM/HTTPServer/logs /logs
RUN ln -s /opt/IBM/HTTPServer/plugin /plugin
COPY httpd-foreground update-conf.sh /opt/IBM/HTTPServer/bin/
RUN chmod +x -R /opt/IBM/HTTPServer

RUN /opt/IBM/HTTPServer/postinstall.sh
RUN /opt/IBM/HTTPServer/bin/update-conf.sh

EXPOSE 80
CMD ["/opt/IBM/HTTPServer/bin/httpd-foreground"]