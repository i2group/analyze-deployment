# i2, i2 Group, the i2 Group logo, and i2group.com are trademarks of N.Harris Computer Corporation.
# © N.Harris Computer Corporation (2022)
#
# SPDX short identifier: MIT
FROM ubuntu:18.04

LABEL maintainer="i2group"
LABEL version="2.7.0"

ARG IHS_ARCHIVE_FILE

#Install the prerequisites.
RUN apt-get update && \
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