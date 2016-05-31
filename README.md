
## About

This is a Vagrant port of ftp://ftp.renci.org/pub/irods/training/ubuntu14-ugm2015.ova

See [iRODS documentation](http://irods.org/documentation/) and more specfically, 
their [training PDF](http://irods.org/wp-content/uploads/2015/06/GettingStartedwiRODS4.1.pdf).

This is a quick and dirty port; it is not fully documented nor supported by anyone.

## Changes made to source ubuntu14-ugm2015.ova

- Changes to meet Vagrant requirements

  - installed VirtualBox Guest additions
  - did not add vagrant user, instead declare `ssh.username  = 'learner'` in Vagrantfile
  - add `learner` to sudoers
  - install sshd
  - localhost on separate line in /etc/hosts to prevent vagrant clobber when setting hostname
  - disabled dnsmasq so it does not conflict with the vagrant landrush plugin management of DNS

- Additions

  - This setup creates separate virtual machines for client, catalog and
  resources - described below - so effects of features such as resource
  allocation and replication can be more clearly demonstrated. That is,
  you should be able to inspect OS filesystems to confirm a file is
  added from `client.vm` to a resource on `rs.vm`.

  - `reiinit` command to quickly init a new user session. When the
tutorial asks you to delete the current irods environment and `iinit` a
different user you can instead use the `reiinit` command to streamline
the process.

            reiinit alice
            reiinit rods

  - The file `tutorial-commands.txt` lists variations on some of the
  commands in the tutorial. For example, resources are created on the
  resource machine `rs1.vm`.

## Vagrant

The Vagrantfile defines three virtual machines: `ies`, `rs1` and `client`. They
are all based on the same vagrant box. Running `vagrant up` will start all three.
Alternatively you can start them individually by name, e.g. `vagrant up ies`.

There are install scripts that Vagrant will run on each of these hosts
to prepare them for their intended roles. These scripts are simple
implementations of the instructions in the `GettingStartedwiRODS4.1.pdf`
linked above. The scripts are not idempotent so if they fail you may be
better off destroying the VM and starting over. If you run `vagrant up`
with `--no-provision` you can run the scripts manually.

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


## Tips

In most cases you should use `vagrant ssh` for shell logins. If you want
to ssh from one guest VM to another, the password for the `learner`
account is `learner`. Password log in as `root` is prohibited and there
are not authorized_keys installed.

