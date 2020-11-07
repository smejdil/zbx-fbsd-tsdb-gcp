#!/bin/sh
#
# Install example API file
#
# Lukas Maly <Iam@LukasMaly.NET> 7.11.2020
#

INSTALL_DIR='/root/zabbix';
mkdir ${INSTALL_DIR};

install -g root -o root -m 700 auth.pl $INSTALL_DIR/
install -g root -o root -m 700 hosts.pl $INSTALL_DIR/


# EOF
