
## Deploy zabbix server on FreeBSD with configuration

This small project is used for install Zabbix server with Zabbix 5.0 LTS on FreeBSD with TimescaleDB on Google Cloud Platform

## Dependencies

- Package on dektop - google-cloud-sdk - Google Cloud SDK for Google Cloud Platform
- Package on dektop - py37-cloudflare - Wrapper for the Cloudflare v4 API
- Package on dektop - py-certbot-dns-cloudflare - Cloudflare DNS plugin for Certbot

## How it works

By Google Cloud SDK is intaled server zbx-fbsd-tsdb. After instalation run scripts for reconfigure OS and install Zabbix with PostgreSQL and TimescaleDB.

## Features

- Install and configure PostgreSQL and TimescaleDB
- Install and configure zabbix_server
- Install and configure zabbix_agentd
- Install and configure Apache httpd and PHP7
- Install and configure ODBC driver for PostgreSQL
- Install and configure Zabbix API scripts in Perl

### Installation

- Configure Google Cloud SDK

```
gcloud config set compute/zone [ZONE]
gcloud config set compute/region [REGION]
gcloud config set project [PROJECT]
```

- Create VM

```
cd /home/malyl/work/zbx-fbsd-tsdb-gcp
./scripts/create-gcp-vm.sh
```
- Connect to VM and run scripts

```
gcloud compute ssh zbx-fbsd-tsdb
sudo su -
./zbx-fbsd-tsdb-gcp/scripts/psql-enable.sh
su -m postgres
createuser -s root
exit
git clone https://github.com/smejdil/zbx-fbsd-tsdb-gcp
portsnap fetch && portsnap extract
./zbx-fbsd-tsdb-gcp/scripts/install-zabbix.sh
```
http://35.246.211.200/zabbix/

- List VM and external IPv4

```
gcloud compute instances list | awk '{print $1" - "$5}' | grep zbx-fbsd-tsdb
zbx-fbsd-tsdb - 35.246.211.200
```
- Create DNS records

```
cli4 --post name='zabbix-gcp' type=A content="35.246.211.200" /zones/:pfsense.cz/dns_records

nslookup zabbix-gcp.pfsense.cz

Name:	zabbix-gcp.pfsense.cz
Address: 35.246.211.200

```
- Install Zabbix API example
- Create Zabbix user for API
```
cd ./zbx-fbsd-tsdb-gcp/zabbix/api/
./install.sh
```
- Get SSL cert
```
cd /usr/ports/security/py-certbot-dns-cloudflare
make install clean

mkdir -p ~/.secrets/certbot/
joe ~/.secrets/certbot/cloudflare.ini
# Cloudflare API credentials used by Certbot
dns_cloudflare_email = XXX
dns_cloudflare_api_key = XXX
chmod 400 ~/.secrets/certbot/cloudflare.ini

certbot certonly \
  --dns-cloudflare \
  --dns-cloudflare-credentials ~/.secrets/certbot/cloudflare.ini \
  --dns-cloudflare-propagation-seconds 60 \
  -d zabbix-gcp.pfsense.cz
...
```
- Enable SSL with Let's encrypt
```
./zbx-fbsd-tsdb-gcp/scripts/ssl-enable.sh
```
https://zabbix-gcp.pfsense.cz

## To do

- Create Zabbix user for API by Zabbix API
- Use Zabbix API for other things
- Other ...