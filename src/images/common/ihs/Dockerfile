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

FROM ibmcom/ibm-http-server:9.0.5.0

LABEL maintainer="IBM i2"
LABEL version="2.1.1"

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

#Use the unzipped toolkit from the ubuntu_toolkit_image
COPY --chown=i2analyze:i2analyze --from=ubuntu_toolkit_image /opt/IBM/i2analyze /opt/IBM/i2analyze

#Add the startupExt file for future startup commands
COPY --chown=i2analyze:i2analyze --from=ubuntu_toolkit_image /opt/IBM/startupExt /opt/IBM/startupExt

COPY setupStore /opt/IBM/keys/stores/setupStore

#Copy utils
COPY --chown=i2analyze:i2analyze --from=ubuntu_toolkit_image /opt/IBM/utils /opt/IBM/utils

#The custom configuration overrides the base configuration in the ubuntu_toolkit_image.
COPY --chown=i2analyze:i2analyze configuration /opt/IBM/i2analyze/toolkit/configuration

USER i2analyze:i2analyze

RUN echo "/opt/IBM/HTTPServer/bin/apachectl start || echo \"Error starting HTTP Server\"" >> /opt/IBM/startupExt

USER root:root

EXPOSE 80 443

ENTRYPOINT /opt/IBM/startupExt && tail -f dev/null
