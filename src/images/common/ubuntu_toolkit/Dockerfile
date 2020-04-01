#/********************************************************************************
# * (C) Copyright IBM Corporation 2018, 2020.
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
LABEL version="2.2.0"

#Install the prerequisites.
RUN dpkg --add-architecture i386 && \
  apt-get update && \
  apt-get install -y \
    file \
    binutils \
    libxml2 \
    libaio1 \
    libpam-ldap:i386 \
    numactl \
    net-tools \
    nano \
    bsdtar \
    curl


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

