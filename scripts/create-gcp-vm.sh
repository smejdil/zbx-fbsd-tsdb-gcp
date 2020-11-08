#!/bin/bash
#
# Create GCP VM FreeBSD 12 for Zabbix and TSDB
#
# Lukas Maly <Iam@LukasMaly.NET> 8.11.2020
#

IMAGE_FBSD=`gcloud compute images list --project freebsd-org-cloud-dev --no-standard-images | grep -i 12-2-release-amd64 | awk '{print $1}'`;

gcloud compute instances create zbx-fbsd-tsdb --image ${IMAGE_FBSD} --image-project=freebsd-org-cloud-dev --metadata-from-file startup-script=scripts/install-gcp.sh
gcloud compute instances add-tags zbx-fbsd-tsdb  --tags=http-server
gcloud compute instances add-tags zbx-fbsd-tsdb  --tags=https-server
gcloud compute instances add-tags zbx-fbsd-tsdb  --tags=zabbix-agent
gcloud compute instances add-tags zbx-fbsd-tsdb  --tags=zabbix-server

# EOF