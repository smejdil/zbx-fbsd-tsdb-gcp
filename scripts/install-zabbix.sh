#!/bin/sh
#
# Install and configure Zabbix with TSDB
#
# Lukas Maly <Iam@LukasMaly.NET> 8.11.2020
#

## PostgreSQL
echo "--- PostgreSQL ---"

/usr/local/etc/rc.d/postgresql enable
/usr/local/etc/rc.d/postgresql initdb
/usr/local/etc/rc.d/postgresql start

# Run manualy before
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
psql -h localhost -d zabbix -a -q -f ./zbx-fbsd-tsdb-gcp/scripts/zabbix-tsdb-init.sql

cd /usr/local/share/zabbix5/server/database/postgresql/
psql -U zabbix zabbix < timescaledb.sql

# EOF