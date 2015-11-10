
## About

This is a Vagrant port of ftp://ftp.renci.org/pub/irods/training/ubuntu14-ugm2015.ova

See [iRODS documentation](http://irods.org/documentation/) and more specfically, 
their [training PDF](http://irods.org/wp-content/uploads/2015/06/GettingStartedwiRODS4.1.pdf).

This is a quick and dirty port; it is not fully documented nor supported by anyone.

## Changes made to source ubuntu14-ugm2015.ova

- Vagrant requirements
  - installed VirtualBox Guest additions
  - did not add vagrant user, instead declare `ssh.username  = 'learner'` in Vagrantfile
  - add `learner` to sudoers
  - install sshd
  - localhost on separate line in /etc/hosts to prevent vagrant clobber when setting hostname
- disabled dnsmasq so it does not conflict with the vagrant landrush plugin management of DNS


## Vagrant

The Vagrantfile defines three virtual machines: `ies`, `rs1` and `client`. They
are all based on the same vagrant box. Running `vagrant up` will start all three.
Alternatively you can start them individually by name, e.g. `vagrant up ies`.

There are install scripts to run on each of these hosts to prepare them for their
intended roles. These scripts are simple implementations of the instructions in the
`GettingStartedwiRODS4.1.pdf` linked above. The scripts are not idempotent so if
they fail you may be better off destroying the VM and starting over.

The `install.env` file defines passwords and other variable values.

The Vagrant `landrush` plugin is recommended (it may be required) to provide a local DNS.

### iCAT-enabled server

`vagrant up ies`

Setup using `/vagrant/install-ies.sh`

This server includes a PostgreSQL database

### resource server

`vagrant up rs1`

Setup using `/vagrant/install-rs.sh`

### client (iCommands only)

`vagrant up client`

Setup using `/vagrant/install-client.sh`

