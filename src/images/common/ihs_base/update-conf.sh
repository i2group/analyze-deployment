#!/bin/bash
#/********************************************************************************
# * (C) Copyright IBM Corporation 2018, 2021.
# *
# * This program and the accompanying materials are made available under the
# * terms of the Eclipse Public License 2.0 which is available at
# * http://www.eclipse.org/legal/epl-2.0.
# *
# * SPDX-License-Identifier: EPL-2.0
# *
# ********************************************************************************/

# Enable SSL if conf/ihsserverkey.kdb exists
cat <<EOF >> /opt/IBM/HTTPServer/conf/httpd.conf

<IfFile conf/ihsserverkey.kdb>
  LoadModule ibm_ssl_module modules/mod_ibm_ssl.so
  Listen 443
  SSLCheckCertificateExpiration 30
  <VirtualHost *:443>
    SSLEnable
    Header always set Strict-Transport-Security "max-age=31536000; includeSubDomains; preload"
  </VirtualHost>
  KeyFile /opt/IBM/HTTPServer/conf/ihsserverkey.kdb
</IfFile>

ErrorLog /dev/stdout
EOF
