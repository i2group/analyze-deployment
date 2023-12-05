# i2, i2 Group, the i2 Group logo, and i2group.com are trademarks of N.Harris Computer Corporation.
# © N.Harris Computer Corporation (2022-2023)
#
# SPDX short identifier: MIT

FROM postgis/postgis:15-master

USER root:root

#Install the prerequisites.
RUN apt-get update && \
    apt-get install -y \
    nano \
    openssh-client

#Create a group for securing the keys
RUN groupadd keys

USER postgres:root

#Copy utils
COPY --from=ubuntu_toolkit_image /opt/i2/utils /opt/i2/utils
