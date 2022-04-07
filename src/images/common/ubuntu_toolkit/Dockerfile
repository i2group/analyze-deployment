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
LABEL version="2.6.1"

#Install the prerequisites.
RUN apt-get update && \
    apt-get install -y \
    file \
    binutils \
    libxml2 \
    libaio1 \
    numactl \
    net-tools \
    nano \
    bsdtar \
    curl && \
  rm -rf /var/lib/apt/lists/* /tmp/*

ENV i2analyzeDir /opt/IBM/i2analyze
ENV toolkitDir ${i2analyzeDir}/toolkit

RUN groupadd i2analyze
RUN useradd -m -g i2analyze i2analyze
#Create a group for securing the keys
RUN groupadd keys && usermod -a -G keys i2analyze

#Copy and extract the i2 Analyze deployment toolkit to the correct location.
COPY --chown=i2analyze:i2analyze i2analyze/i2analyze.tar.gz ${i2analyzeDir}/i2analyze.tar.gz

#Add the startupExt file for future startup commands
COPY --chown=i2analyze:i2analyze startupExt /opt/IBM

USER i2analyze:i2analyze

RUN bsdtar -xzpf ${i2analyzeDir}/i2analyze.tar.gz -C ${i2analyzeDir} \
    && rm -f ${i2analyzeDir}/i2analyze.tar.gz \
    && ls ${i2analyzeDir}

COPY --chown=i2analyze:i2analyze i2analyze/license_acknowledgment.txt ${i2analyzeDir}/license_acknowledgment.txt

#Copy the base configuration to the correct location.
COPY --chown=i2analyze:i2analyze configuration ${toolkitDir}/configuration

#Copy utils
COPY --chown=i2analyze:i2analyze utils /opt/IBM/utils

#Since its a base image put user back to root
USER root:root

