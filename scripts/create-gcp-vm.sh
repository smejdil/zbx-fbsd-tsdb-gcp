#!/bin/bash
#
# Create GCP FreeBSD for Zabbix and TSDB
#
# Lukas Maly <Iam@LukasMaly.NET> 7.11.2020
#

IMAGE_FBSD="freebsd-12-2-release-amd64";

gcloud compute instances create zbx-fbsd-tsdb --image ${IMAGE_FBSD} --image-project=freebsd-org-cloud-dev --metadata-from-file startup-script=scripts/install-gcp.sh
gcloud compute instances add-tags zbx-fbsd-tsdb  --tags=http-server
gcloud compute instances add-tags zbx-fbsd-tsdb  --tags=https-server
gcloud compute instances add-tags zbx-fbsd-tsdb  --tags=zabbix-agent
gcloud compute instances add-tags zbx-fbsd-tsdb  --tags=zabbix-server

# EOF