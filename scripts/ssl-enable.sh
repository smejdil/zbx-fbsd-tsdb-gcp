#!/bin/sh
#
# Enable SSL
#
# Lukas Maly <Iam@LukasMaly.NET> 8.11.2020
#

## SSL
echo "--- SSL ---"

cp -v ./zbx-fbsd-tsdb-gcp/files/httpd-ssl.conf.patch /usr/local/etc/apache24/extra/
cd /usr/local/etc/apache24/extra/
patch < httpd-ssl.conf.patch

cp -v /usr/local/etc/apache24/httpd.conf.sample /usr/local/etc/apache24/httpd.conf
cp -v ./zbx-fbsd-tsdb-gcp/files/httpd.conf.ssl.patch /usr/local/etc/apache24/
cd /usr/local/etc/apache24/
patch < httpd.conf.ssl.patch

/usr/local/etc/rc.d/apache24 restart

# https://zabbix-gcp.pfsense.cz

# EOF