
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
su -m postgres
createuser -s root
./zbx-fbsd-tsdb-gcp/scripts/install_zabbix.sh
```

- List VM and external IPv4

```
gcloud compute instances list | awk '{print $1" - "$5}' | grep zbx-fbsd-tsdb
zbx-fbsd-tsdb - 35.246.211.200
```
- Create DNS records

```
cli4 --post name='zabbix-gcp' type=A content="35.246.211.200" /zones/:pfsense.cz/dns_records
```
## To do

- Create Zabbix user by Zabbix API
- Use Zabbix API for other things
- Other ...


