# i2, i2 Group, the i2 Group logo, and i2group.com are trademarks of N.Harris Computer Corporation.
# © N.Harris Computer Corporation (2022-2023)
#
# SPDX short identifier: MIT

FROM base_ihs_image

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

#Use the unzipped toolkit from the ubuntu_toolkit_image
COPY --chown=i2analyze:i2analyze --from=ubuntu_toolkit_image /opt/i2/i2analyze /opt/i2/i2analyze

#Add the startupExt file for future startup commands
COPY --chown=i2analyze:i2analyze --from=ubuntu_toolkit_image /opt/i2/startupExt /opt/i2/startupExt

COPY setupStore /opt/i2/keys/stores/setupStore

#Copy utils
COPY --chown=i2analyze:i2analyze --from=ubuntu_toolkit_image /opt/i2/utils /opt/i2/utils

#The custom configuration overrides the base configuration in the ubuntu_toolkit_image.
COPY --chown=i2analyze:i2analyze configuration /opt/i2/i2analyze/toolkit/configuration

USER i2analyze:i2analyze

RUN echo "/opt/IBM/HTTPServer/bin/apachectl start || echo \"Error starting HTTP Server\"" >> /opt/i2/startupExt

USER root:root

EXPOSE 80 443

ENTRYPOINT /opt/i2/startupExt && tail -f dev/null
