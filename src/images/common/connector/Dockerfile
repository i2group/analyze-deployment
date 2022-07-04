# i2, i2 Group, the i2 Group logo, and i2group.com are trademarks of N.Harris Computer Corporation.
# © N.Harris Computer Corporation (2022)
#
# SPDX short identifier: MIT

FROM ubuntu:18.04

LABEL maintainer="i2group"
LABEL version="2.7.0"

#Install the prerequisites.
RUN apt-get update && \
    apt-get install -y \
    curl \
    nano

RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -

#Install Node.js to host the example connector.
RUN apt-get install -y nodejs

#Configure the i2analyze user and group.
RUN groupadd i2analyze
RUN useradd -m -g i2analyze i2analyze

#Create a group for securing the keys.
RUN groupadd keys && usermod -a -G keys i2analyze

#Use the extracted toolkit from the ubuntu_toolkit_image to copy the example connector to the image.
COPY --chown=i2analyze:i2analyze --from=ubuntu_toolkit_image /opt/i2/i2analyze/toolkit/examples/connectors/example-connector /opt/i2/i2analyze/example_connector

#Add the startupExt file for future startup commands
COPY --chown=i2analyze:i2analyze --from=ubuntu_toolkit_image /opt/i2/startupExt /opt/i2/startupExt

#Add the populated security-config.json for the example connector to the connector image.
COPY --chown=i2analyze:i2analyze security-config.json /opt/i2/i2analyze/example_connector/security-config.json

#Copy the utils to the container.
COPY --chown=i2analyze:i2analyze --from=ubuntu_toolkit_image /opt/i2/utils /opt/i2/utils

#Remove hard coded reference to user random file
#see https://github.com/openssl/openssl/issues/7754
RUN sed -i -E 's/^(RANDFILE.*HOME.*)/#\1/' /etc/ssl/openssl.cnf

WORKDIR /opt/i2/i2analyze/example_connector

#Install the prerequisites for the example connector.
RUN npm install

USER i2analyze:i2analyze

#Start the example connector.
RUN echo "nodejs /opt/i2/i2analyze/example_connector/app.js || echo \"Error starting example connector\"" >> /opt/i2/startupExt

#Expose the port that the example connector uses.
EXPOSE 3700

ENTRYPOINT /opt/i2/startupExt && tail -f /dev/null
