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
    openssl \
    nano

COPY ca /opt/i2/ca

ENTRYPOINT echo "ca started" && tail -f dev/null
