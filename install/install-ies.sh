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

sudo apt-get install -y postgresql

sudo -u postgres psql -c "CREATE DATABASE \"$DB_NAME\";"
 
sudo -u postgres psql -c "CREATE USER $DB_USER WITH PASSWORD '$DB_USER_PASS'";
 
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE \"$DB_NAME\" to $DB_USER;"


mkdir -p /vagrant/scratch
cd /vagrant/scratch

wget -nc ftp://ftp.renci.org/pub/irods/releases/${IRODS_VERSION}/ubuntu14/irods-icat-${IRODS_VERSION}-ubuntu14-x86_64.deb \
  || { echo "FATAL: could not download icat package"; exit 1; }
wget -nc ftp://ftp.renci.org/pub/irods/releases/${IRODS_VERSION}/ubuntu14/irods-database-plugin-postgres-${PG_PLUGIN_VERSION}-ubuntu14-x86_64.deb \
  || { echo "FATAL: could not download db plugin package"; exit 1; }
wget -nc ftp://ftp.renci.org/pub/irods/releases/${IRODS_VERSION}/ubuntu14/irods-runtime-${IRODS_VERSION}-ubuntu14-x86_64.deb \
  || { echo "FATAL: could not download irods runtime package"; exit 1; }
wget -nc ftp://ftp.renci.org/pub/irods/releases/${IRODS_VERSION}/ubuntu14/irods-dev-${IRODS_VERSION}-ubuntu14-x86_64.deb \
  || { echo "FATAL: could not download irods dev package"; exit 1; }
wget -nc ftp://ftp.renci.org/pub/irods/training/training-example-1.0.deb \
 || { echo "FATAL: could not download irods training package"; exit 1; }

sudo dpkg -i irods-icat-${IRODS_VERSION}-ubuntu14-x86_64.deb \
             irods-database-plugin-postgres-${PG_PLUGIN_VERSION}-ubuntu14-x86_64.deb \
             irods-runtime-${IRODS_VERSION}-ubuntu14-x86_64.deb \
             irods-dev-${IRODS_VERSION}-ubuntu14-x86_64.deb \
             training-example-1.0.deb

sudo apt-get -y install libtar-dev

sudo apt-get -f -y install

cd

echo | sudo /var/lib/irods/packaging/setup_irods.sh <<EOD
$SRV_ACCT
$SRV_GRP
$ICAT_SERVER_ZONE
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
$ICAT_ADMIN_PASS
yes
$DB_SRV_HOST
$DB_SRV_PORT
$DB_NAME
$DB_USER
$DB_USER_PASS
yes
EOD

sudo touch /var/lib/irods/.vagrant-provisioned
