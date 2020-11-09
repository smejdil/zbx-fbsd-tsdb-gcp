#!/bin/sh
#
# Install and configure Zabbix with TSDB
#
# Lukas Maly <Iam@LukasMaly.NET> 9.11.2020
#

## PostgreSQL
echo "--- PostgreSQL ---"

# Run manualy before

#/usr/local/etc/rc.d/postgresql enable
#/usr/local/etc/rc.d/postgresql initdb
#/usr/local/etc/rc.d/postgresql start

#su -m postgres
#createuser -s root

psql -l

mkdir -p /data/pgsql
chown postgres:postgres /data/pgsql

psql -h localhost -d template1 -a -q -f ./zbx-fbsd-tsdb-gcp/scripts/zabbix-init.sql
#psql -h localhost -d database -U postgres -p 5432 -a -q -f /path/to/the/file.sql

echo "--- Import Zabbix schema ---"
cd /usr/local/share/zabbix5/server/database/postgresql/
cat schema.sql | psql -U zabbix zabbix
psql -U zabbix zabbix < images.sql
psql -U zabbix zabbix < data.sql

echo "--- PostgreSQL + TimescaleDB ---"
cp -v /var/db/postgres/data12/postgresql.conf /var/db/postgres/data12/postgresql.conf-orig
sed -e "s/#shared_preload_libraries = \'\'/shared_preload_libraries = \'timescaledb\'/" -i "" /var/db/postgres/data12/postgresql.conf
diff -u /var/db/postgres/data12/postgresql.conf-orig /var/db/postgres/data12/postgresql.conf


/usr/local/etc/rc.d/postgresql restart

echo "--- Inicializace TimescaleDB ---"
cd
psql -h localhost -d zabbix -a -q -f ./zbx-fbsd-tsdb-gcp/scripts/zabbix-tsdb-init.sql

cd /usr/local/share/zabbix5/server/database/postgresql/
psql -U zabbix zabbix < timescaledb.sql

## Zabbix
echo "--- Rekconfigure Zabbix server ---"

/usr/local/etc/rc.d/zabbix_server enable

cd
cp -v ./zbx-fbsd-tsdb-gcp/files/make.conf /etc/
mkdir -p /var/db/ports/net-mgmt_zabbix5-server/
cp -v ./zbx-fbsd-tsdb-gcp/files/net-mgmt_zabbix5-server-options /var/db/ports/net-mgmt_zabbix5-server/options

# Rekompilation Zabbix server for PostgreSQL support
echo "--- Recompile Zabbix server ---"
portupgrade -f zabbix5-server

cp -v /usr/local/etc/zabbix5/zabbix_server.conf.sample /usr/local/etc/zabbix5/zabbix_server.conf
sed -e "s/# DBSchema=/DBSchema=public/" -i "" /usr/local/etc/zabbix5/zabbix_server.conf
sed -e "s/# DBPassword=/DBPassword=ZBX5_FBSD12_PSQL12_TSDB17/" -i "" /usr/local/etc/zabbix5/zabbix_server.conf

/usr/local/etc/rc.d/zabbix_server start

mkdir /var/log/zabbix
ln -s /tmp/zabbix_server.log /var/log/zabbix/

echo "--- Rekconfigure Zabbix agent ---"
/usr/local/etc/rc.d/zabbix_agentd enable

cp -v /usr/local/etc/zabbix5/zabbix_agentd.conf.sample /usr/local/etc/zabbix5/zabbix_agentd.conf
sed -e "s/Hostname=Zabbix server/Hostname=zbx-fbsd-tsdb/" -i "" /usr/local/etc/zabbix5/zabbix_agentd.conf
sed -e "s/# Include=\/usr\/local\/etc\/zabbix5\/zabbix_agentd.conf.d\/*.conf/Include=\/usr\/local\/etc\/zabbix5\/zabbix_agentd.conf.d\/*.conf/" -i "" /usr/local/etc/zabbix5/zabbix_agentd.conf

/usr/local/etc/rc.d/zabbix_agentd restart

ln -s /tmp/zabbix_agentd.log /var/log/zabbix/

## Apache
echo "--- Rekconfigure Apache web server ---"

/usr/local/etc/rc.d/apache24 enable
mkdir /var/log/apache/

cp -v ./zbx-fbsd-tsdb-gcp/files/httpd.conf.patch /usr/local/etc/apache24/
cp -v /usr/local/etc/apache24/httpd.conf.sample /usr/local/etc/apache24/httpd.conf

cd /usr/local/etc/apache24
patch < httpd.conf.patch

cd
cp -v ./zbx-fbsd-tsdb-gcp/files/zabbix.conf /usr/local/etc/apache24/Includes/

/usr/local/etc/rc.d/apache24 restart

## Zabbix frontend

cd
mkdir -p /var/db/ports/net-mgmt_zabbix5-frontend/
cp -v ./zbx-fbsd-tsdb-gcp/files/net-mgmt_zabbix5-frontend-options /var/db/ports/net-mgmt_zabbix5-frontend/options

# Rekompilation Zabbix Frontend for PostgreSQL support
echo "--- Recompile Zabbix frontend ---"

portupgrade -f zabbix5-frontend

cp -v ./zbx-fbsd-tsdb-gcp/files/zabbix.conf.php.patch /usr/local/www/zabbix5/conf/
cp -v /usr/local/www/zabbix5/conf/zabbix.conf.php.example /usr/local/www/zabbix5/conf/zabbix.conf.php
cd /usr/local/www/zabbix5/conf/
patch < zabbix.conf.php.patch
chown www:www zabbix.conf.php
chmod 400 zabbix.conf.php

# http://34.107.115.225/zabbix/
# Admin
# zabbix

# EOF