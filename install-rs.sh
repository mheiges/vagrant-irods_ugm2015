#!/bin/bash
Bin="$( readlink -f -- "$( dirname -- "$0" )" )"

#set -x

source "${Bin}/install.env"

if [ -f /var/lib/irods/.vagrant-provisioned ]; then
  echo "iRODS is already provisioned. If not provisioned correctly then"
  echo "you will need to either start from a naive instance or fix"
  echo "manually. This script is not restartable."
  exit 1
fi

sudo apt-get update

mkdir -p /vagrant/scratch
cd /vagrant/scratch

wget -nc ftp://ftp.renci.org/pub/irods/releases/${IRODS_VERSION}/ubuntu14/irods-resource-${IRODS_VERSION}-ubuntu14-x86_64.deb

#sudo dpkg -i irods-resource-4.1.6-ubuntu14-x86_64.deb
sudo dpkg -i irods-resource-${IRODS_VERSION}-ubuntu14-x86_64.deb

sudo apt-get -f -y install

cd

echo | sudo /var/lib/irods/packaging/setup_irods.sh <<EOD
$SRV_ACCT
$SRV_GRP
$SRV_PORT
$SRV_PORT_RANGE_START
$SRV_PORT_RANGE_END
$DEFAULT_VAULT_DIR
$SRV_ZONE_KEY
$SRV_NEGOTIATION_KEY
$CTRL_PLANE_PORT
$CTRL_PLANE_KEY
$SCHEMA_BASE_URI
$ICAT_ADMIN_USER
yes
$ICAT_SERVER
$ICAT_SERVER_ZONE
yes
$ICAT_ADMIN_PASS
EOD

sudo touch /var/lib/irods/.vagrant-provisioned
