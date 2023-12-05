# i2, i2 Group, the i2 Group logo, and i2group.com are trademarks of N.Harris Computer Corporation.
# © N.Harris Computer Corporation (2022-2023)
#
# SPDX short identifier: MIT

FROM postgis/postgis:15-master

LABEL maintainer="i2group"
LABEL version="2.9.0"

#Install the prerequisites.
RUN apt-get update && \
    apt-get install -y \
    nano \
    libarchive-tools

RUN groupadd i2analyze
RUN useradd -m -g i2analyze i2analyze
#Create a group for securing the keys
RUN groupadd keys && usermod -a -G keys i2analyze


#Add the startupExt file for future startup commands
COPY --chown=i2analyze:i2analyze --from=ubuntu_toolkit_image /opt/i2/startupExt /opt/i2/startupExt

#Copy utils
COPY --chown=i2analyze:i2analyze --from=ubuntu_toolkit_image /opt/i2/utils /opt/i2/utils

#Change the user that runs PSQL commands.
USER i2analyze:i2analyze

#Copy the example data to ingest.
COPY --chown=i2analyze:i2analyze example /opt/i2/i2analyze/example

#Copy example ingestion script.
COPY --chown=i2analyze:i2analyze ingestExampleData /opt/i2/i2analyze/ingestExampleData

#Add PSQL to the PATH.
ENV PATH=$PATH:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/lib/postgresql/15/bin

ENTRYPOINT tail -f /dev/null
