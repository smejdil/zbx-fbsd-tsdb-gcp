#!/bin/sh
pkg install -y bash
pkg install -y mc
pkg install -y joe
pkg install -y screen
pkg install -y portupgrade
pkg install -y postgresql12-server
pkg install -y postgresql-odbc
pkg install -y timescaledb
pkg install -y apache24
pkg install -y mod_php74
pkg install -y dialog4ports
pkg install -y pkgconf
pkg install -y gmake
pkg install -y popt
pkg install -y openipmi
pkg install -y nmap
pkg install -y libtextstyle
pkg install -y gettext-tools
pkg install -y p5-Locale-gettext
pkg install -y help2man
pkg install -y p5-Locale-libintl
pkg install -y p5-Text-Unidecode
pkg install -y p5-Unicode-EastAsianWidth
pkg install -y texinfo
pkg install -y m4
pkg install -y autoconf-wrapper
pkg install -y autoconf
pkg install -y php74-pgsql
pkg install -y php74-openssl
pkg install -y zabbix5-server
pkg install -y zabbix5-agent
pkg install -y zabbix5-frontend
pkg install -y zabbix5-java
pkg install -y p5-JSON-RPC
pkg install -y git
git clone https://github.com/smejdil/zbx-fbsd-tsdb-gcp
portsnap fetch && portsnap extract
# EOF