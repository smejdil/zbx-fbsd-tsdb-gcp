#!/bin/sh
#
# Startup and init PostgreSQL
#
# Lukas Maly <Iam@LukasMaly.NET> 8.11.2020
#

## PostgreSQL
echo "--- PostgreSQL ---"

/usr/local/etc/rc.d/postgresql enable
/usr/local/etc/rc.d/postgresql initdb
/usr/local/etc/rc.d/postgresql start

# EOF
