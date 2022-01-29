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

FROM ubuntu_toolkit_image

RUN apt-get install -y \
    openssh-server

#The host name of the Docker container.
ARG hostname=zookeeper2.eianet
ENV hostname $hostname

#The custom configuration overrides the base configuration in the ubuntu_toolkit_image.
COPY --chown=i2analyze:i2analyze configuration ${toolkitDir}/configuration

#Change the user that runs commands.
USER i2analyze:i2analyze

#Install ZooKeeper.
RUN /opt/IBM/i2analyze/toolkit/scripts/setup -t installZookeeper

#Create the ZooKeeper host and the configuration for the ZooKeeper hosts on this server.
RUN /opt/IBM/i2analyze/toolkit/scripts/setup -t createZkHosts --hostname ${hostname}

RUN echo "/opt/IBM/i2analyze/toolkit/scripts/setup -t startZkHosts --hostname ${hostname} || echo \"Error stating Zookeeper host in ${hostname}\"" >> /opt/IBM/startupExt

#Start ZooKeeper and upload the Solr configuration to ZooKeeper.
ENTRYPOINT /opt/IBM/startupExt && tail -f /dev/null
