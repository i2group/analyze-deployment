# MIT License
#
# Copyright (c) 2022, N. Harris Computer Corporation
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
FROM ubuntu:18.04

LABEL maintainer="i2group"
LABEL version="2.6.0"

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