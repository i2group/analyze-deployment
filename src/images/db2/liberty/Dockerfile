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

FROM base_client_image

RUN apt-get install -y \
    openssh-client

#The custom configuration overrides the base configuration in the ubuntu_toolkit_image.
COPY --chown=i2analyze:i2analyze configuration ${toolkitDir}/configuration

#Change the user that runs DB2 commands.
USER i2analyze:db2iusr1

#Catalog the remote DB2 node to enable deletion by rule.
RUN . /home/db2inst1/sqllib/db2profile && ${toolkitDir}/scripts/setup -t catalogRemoteDB2Nodes
RUN . /home/db2inst1/sqllib/db2profile && ${toolkitDir}/scripts/setup -t catalogDB2Databases

USER i2analyze:i2analyze

#Install the dependencies.
RUN ${toolkitDir}/scripts/setup -t installLiberty

#Deploy Liberty with the i2 Analyze application.
RUN ${toolkitDir}/scripts/setup -t deployLiberty

#Create an example user registry in Liberty.
RUN ${toolkitDir}/scripts/setup -t ensureExampleUserRegistry
COPY --chown=i2analyze:i2analyze user.registry.xml /opt/IBM/i2analyze/deploy/wlp/usr/shared/config/

RUN echo "export JAVA_HOME=/opt/IBM/i2analyze/deploy/java && /opt/IBM/i2analyze/toolkit/scripts/setup -t startLiberty || echo \"Error starting Liberty\"" >> /opt/IBM/startupExt

EXPOSE 9082 9445

#Start the Liberty server that hosts i2 Analyze.
ENTRYPOINT /opt/IBM/startupExt && tail -f /dev/null
