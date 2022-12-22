# i2, i2 Group, the i2 Group logo, and i2group.com are trademarks of N.Harris Computer Corporation.
# © N.Harris Computer Corporation (2022)
#
# SPDX short identifier: MIT

FROM mcr.microsoft.com/mssql-tools

LABEL maintainer="i2group"
LABEL version="2.8.0"

ENV i2analyzeDir /opt/i2/i2analyze
ENV toolkitDir ${i2analyzeDir}/toolkit

#Install the prerequisites.
RUN dpkg --add-architecture i386 && \
  apt-get update && \
  apt-get install -y \
    nano \
    bsdtar \
    openssh-client \
    net-tools

RUN groupadd i2analyze
RUN useradd -m -g i2analyze i2analyze
#Create a group for securing the keys
RUN groupadd keys && usermod -a -G keys i2analyze

#Use the unzipped toolkit from the ubuntu_toolkit_image
COPY --chown=i2analyze:i2analyze --from=ubuntu_toolkit_image ${i2analyzeDir} ${i2analyzeDir}

#Add the startupExt file for future startup commands
COPY --chown=i2analyze:i2analyze --from=ubuntu_toolkit_image /opt/i2/startupExt /opt/i2/startupExt

#Copy utils
COPY --chown=i2analyze:i2analyze --from=ubuntu_toolkit_image /opt/i2/utils /opt/i2/utils

#The custom configuration overrides the base configuration in the ubuntu_toolkit_image.
COPY --chown=i2analyze:i2analyze configuration ${toolkitDir}/configuration

#Change the user that runs Microsoft SQL Tools commands.
USER i2analyze:i2analyze

#Install the dependencies.
RUN ${toolkitDir}/scripts/setup -t installLiberty

#Deploy Liberty with the i2 Analyze application.
RUN ${toolkitDir}/scripts/setup -t deployLiberty

#Create an example user registry in Liberty.
RUN ${toolkitDir}/scripts/setup -t ensureExampleUserRegistry
COPY --chown=i2analyze:i2analyze user.registry.xml /opt/i2/i2analyze/deploy/wlp/usr/shared/config/

RUN echo "export JAVA_HOME=/opt/i2/i2analyze/deploy/java && /opt/i2/i2analyze/toolkit/scripts/setup -t startLiberty || echo \"Error starting Liberty\"" >> /opt/i2/startupExt

EXPOSE 9082 9445

#Start the Liberty server that hosts i2 Analyze.
ENTRYPOINT /opt/i2/startupExt && tail -f /dev/null
