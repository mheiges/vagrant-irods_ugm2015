
About
=====

This is a Vagrant port of the iRODS Consortium's 2015 User Group
tutorial virtual-machine
(ftp://ftp.renci.org/pub/irods/training/ubuntu14-ugm2015.ova) with some
modifications noted in the **Technical Background** below.

See [iRODS documentation](http://irods.org/documentation/) and more specfically, 
their [training PDF](http://irods.org/wp-content/uploads/2015/06/GettingStartedwiRODS4.1.pdf).

This is a quick and dirty port; it is not fully documented nor supported by anyone.

The base box is Ubuntu without iRODS installed. You can install iRODS
manually per the tutorial or use the provided install scripts.

Prerequisites
=====

The host computer needs the following software.

Vagrant
---------------

Vagrant manages the lifecycle of the virtual machine, following by the instructions in the `Vagrantfile` that is included with this project.

[https://www.vagrantup.com/downloads.html](https://www.vagrantup.com/downloads.html)

You should refer to Vagrant documentation and related online forums for information not covered in this document.

VirtualBox
------------------

Vagrant needs VirtualBox to host the virtual machine defined in this project's `Vagrantfile`. Other virtualization software (e.g. VMWare) are not compatible with this Vagrant project as it is currently configured.

[https://www.virtualbox.org/wiki/Downloads](https://www.virtualbox.org/wiki/Downloads)

You should refer to VirtualBox documentation and related online forums for information not covered in this document.

Vagrant Landrush Plugin (Optional)
--------------------------------------

The [Landrush](https://github.com/phinze/landrush) plugin for Vagrant
provides a local DNS where guest hostnames are registered. This permits,
for example, the `rs1` guest to contact the iCAT enabled server by its
`ies.vm` hostname - a requirement for iRODS installation and function.
This plugin is not strictly required but it makes life easier than
editing `/etc/hosts` files. This plugin has maximum benefit for OS X
hosts, some benefit for Linux hosts and no benefit for Windows. Windows
hosts will need to edit the `hosts` file.

If you do not use the landrush plugin (or other similar DNS provider)
you will need to `vagrant up --no-provision` each box separately,
manually cross-reference the guests in `/etc/hosts` files and then
manually provision with the shell scripts in the `install` directory
(which should be accessible from each guest at `/vagrant/install`).

Usage
=====

The Vagrantfile defines three virtual machines: `ies`, `rs1` and
`client`. They are all based on the same Ubuntu box.

Running `vagrant up` will start all three guest machines. Alternatively
you can start them individually by name, e.g. `vagrant up ies`.

There are install scripts that Vagrant will run on each of these hosts
to prepare them for their intended roles. These scripts are simple
implementations of the instructions in the `GettingStartedwiRODS4.1.pdf`
linked above. The scripts are not idempotent so if they fail you may be
better off destroying the VM and starting over. If you run `vagrant up`
with `--no-provision` you can run the scripts manually or manually
install iRODS as described in the tutorial.

The `install/install.env` file included with this project defines
passwords and other variable values.


iCAT-enabled server
------------------

`vagrant up ies`

`vagrant ssh ies`

Setup using `/vagrant/install-ies.sh`

This server includes a PostgreSQL database

resource server
------------------

`vagrant up rs1`

`vagrant ssh rs1`

Setup using `/vagrant/install-rs.sh`

client (iCommands only)
------------------

`vagrant up client`

`vagrant ssh client`

Setup using `/vagrant/install-client.sh`


Custom Rules
=====

_Deprecation: This will be moved to the `vagrant-irods_ebrc` project_

- `contrib/ebrc.re` in the Vagrant project defines some example custom
rules that can be installed.

Create the necessary resources that are used in the rules (e.g. `replResc`).

On the IES node, copy the file to `/etc/irods/`

        sudo cp /vagrant/contrib/ebrc.re /etc/irods/

Then edit `/etc/irods/server_config.json` and prepend the rule set to the existing list:

        "re_rulebase_set": [
        {
        "filename": "ebrc"
        },
        {
        "filename": "core"
        }
        ]


Tips
=====

In most cases you should use `vagrant ssh` for shell logins. If you want
to ssh from one guest VM to another, the password for the `learner`
account is `learner`. Password log in as `root` is prohibited and there
are not authorized_keys installed.

Technical Background
=====

Changes made to the source ubuntu14-ugm2015.ova
------------------

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
