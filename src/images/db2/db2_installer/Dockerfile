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
