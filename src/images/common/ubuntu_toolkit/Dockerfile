# i2, i2 Group, the i2 Group logo, and i2group.com are trademarks of N.Harris Computer Corporation.
# © N.Harris Computer Corporation (2022)
#
# SPDX short identifier: MIT

FROM ubuntu:18.04

LABEL maintainer="i2group"
LABEL version="2.8.0"

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

ENV i2analyzeDir /opt/i2/i2analyze
ENV toolkitDir ${i2analyzeDir}/toolkit

RUN groupadd i2analyze
RUN useradd -m -g i2analyze i2analyze
#Create a group for securing the keys
RUN groupadd keys && usermod -a -G keys i2analyze

#Copy and extract the i2 Analyze deployment toolkit to the correct location.
COPY --chown=i2analyze:i2analyze i2analyze/i2analyze.tar.gz ${i2analyzeDir}/i2analyze.tar.gz

#Add the startupExt file for future startup commands
COPY --chown=i2analyze:i2analyze startupExt /opt/i2

USER i2analyze:i2analyze

RUN bsdtar -xzpf ${i2analyzeDir}/i2analyze.tar.gz -C ${i2analyzeDir} \
    && rm -f ${i2analyzeDir}/i2analyze.tar.gz \
    && ls ${i2analyzeDir}

COPY --chown=i2analyze:i2analyze i2analyze/license_acknowledgment.txt ${i2analyzeDir}/license_acknowledgment.txt

#Copy the base configuration to the correct location.
COPY --chown=i2analyze:i2analyze configuration ${toolkitDir}/configuration

#Copy utils
COPY --chown=i2analyze:i2analyze utils /opt/i2/utils

#Since its a base image put user back to root
USER root:root

