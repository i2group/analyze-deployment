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
