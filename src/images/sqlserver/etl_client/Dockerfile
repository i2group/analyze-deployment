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

FROM mcr.microsoft.com/mssql-tools

LABEL maintainer="i2group"
LABEL version="2.6.1"

#Install the prerequisites.
RUN dpkg --add-architecture i386 && \
  apt-get update && \
  apt-get install -y \
    nano \
    bsdtar

RUN groupadd i2analyze
RUN useradd -m -g i2analyze i2analyze
#Create a group for securing the keys
RUN groupadd keys && usermod -a -G keys i2analyze


#Add the startupExt file for future startup commands
COPY --chown=i2analyze:i2analyze --from=ubuntu_toolkit_image /opt/IBM/startupExt /opt/IBM/startupExt

#Copy utils
COPY --chown=i2analyze:i2analyze --from=ubuntu_toolkit_image /opt/IBM/utils /opt/IBM/utils

#Change the user that runs Microsoft SQL Tools commands.
USER i2analyze:i2analyze

#Copy the example data to ingest.
COPY --chown=i2analyze:i2analyze example /opt/IBM/i2analyze/example

#Copy example ingestion script.
COPY --chown=i2analyze:i2analyze ingestExampleData /opt/IBM/i2analyze/ingestExampleData

#Add Microsoft SQL tools to the PATH.
ENV PATH=$PATH:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/mssql-tools/bin

ENTRYPOINT tail -f /dev/null
