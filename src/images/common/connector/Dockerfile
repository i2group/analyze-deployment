# MIT License
#
# Copyright (c) 2022, N. Harris Computer Corporation
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

FROM ubuntu:18.04

LABEL maintainer="i2group"
LABEL version="2.6.1"

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
COPY --chown=i2analyze:i2analyze --from=ubuntu_toolkit_image /opt/IBM/i2analyze/toolkit/examples/connectors/example-connector /opt/IBM/i2analyze/example_connector

#Add the startupExt file for future startup commands
COPY --chown=i2analyze:i2analyze --from=ubuntu_toolkit_image /opt/IBM/startupExt /opt/IBM/startupExt

#Add the populated security-config.json for the example connector to the connector image.
COPY --chown=i2analyze:i2analyze security-config.json /opt/IBM/i2analyze/example_connector/security-config.json

#Copy the utils to the container.
COPY --chown=i2analyze:i2analyze --from=ubuntu_toolkit_image /opt/IBM/utils /opt/IBM/utils

#Remove hard coded reference to user random file
#see https://github.com/openssl/openssl/issues/7754
RUN sed -i -E 's/^(RANDFILE.*HOME.*)/#\1/' /etc/ssl/openssl.cnf

WORKDIR /opt/IBM/i2analyze/example_connector

#Install the prerequisites for the example connector.
RUN npm install

USER i2analyze:i2analyze

#Start the example connector.
RUN echo "nodejs /opt/IBM/i2analyze/example_connector/app.js || echo \"Error starting example connector\"" >> /opt/IBM/startupExt

#Expose the port that the example connector uses.
EXPOSE 3700

ENTRYPOINT /opt/IBM/startupExt && tail -f /dev/null
