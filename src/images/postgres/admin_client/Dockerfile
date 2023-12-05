# i2, i2 Group, the i2 Group logo, and i2group.com are trademarks of N.Harris Computer Corporation.
# © N.Harris Computer Corporation (2022-2023)
#
# SPDX short identifier: MIT

FROM postgis/postgis:15-master

LABEL maintainer="i2group"
LABEL version="2.9.0"

ENV i2analyzeDir /opt/i2/i2analyze
ENV toolkitDir ${i2analyzeDir}/toolkit

#Install the prerequisites.
RUN apt-get update && \
    apt-get install -y \
    nano \
    libarchive-tools \
    openssh-client

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

#Change the user that runs PSQL commands.
USER i2analyze:i2analyze

#Install the dependencies.
RUN ${toolkitDir}/scripts/setup -t installZookeeper
RUN ${toolkitDir}/scripts/setup -t installSolr

RUN echo "echo \"Admin client: Started\"" >> /opt/i2/startupExt

ENTRYPOINT /opt/i2/startupExt && tail -f dev/null
