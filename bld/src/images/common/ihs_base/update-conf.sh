#!/bin/bash
# i2, i2 Group, the i2 Group logo, and i2group.com are trademarks of N.Harris Computer Corporation.
# © N.Harris Computer Corporation (2022-2023)
#
# SPDX short identifier: MIT

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
