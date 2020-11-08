#!/bin/sh
#
# Install example API file and Perl modul
#
# Lukas Maly <Iam@LukasMaly.NET> 8.11.2020
#

cd /usr/ports/devel/p5-JSON-RPC
make install clean

echo "--- Install API example file ---"

INSTALL_DIR='/root/zabbix';
mkdir ${INSTALL_DIR};

install -g wheel -o root -m 700 auth.pl $INSTALL_DIR/
install -g wheel -o root -m 700 hosts.pl $INSTALL_DIR/


# EOF
