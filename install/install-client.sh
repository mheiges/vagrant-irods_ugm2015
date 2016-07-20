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

wget -nc ftp://ftp.renci.org/pub/irods/releases/${IRODS_VERSION}/ubuntu14/irods-icommands-${IRODS_VERSION}-ubuntu14-x86_64.deb \
 || { echo "FATAL: could not download irods icommands package"; exit 1; }

sudo dpkg -i irods-icommands-${IRODS_VERSION}-ubuntu14-x86_64.deb

sudo apt-get -f -y install

cd

sudo touch /var/lib/irods/.vagrant-provisioned
