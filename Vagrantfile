BOX_URL = 'http://software.apidb.org/vagrant/irods-ugm2015.json'
IRODS_HOSTS = {
  :ies => { # iCAT-enabled Server
    :vagrant_box     => 'irods-ugm2015',
    :vagrant_box_url => BOX_URL,
    :wf_hostname     => 'ies.vm',
  },
  :rs1 => { # Resource Server
    :vagrant_box     => 'irods-ugm2015',
    :vagrant_box_url => BOX_URL,
    :wf_hostname     => 'rs1.vm',
  },
  :client => { # server with iCommands only
    :vagrant_box     => 'irods-ugm2015',
    :vagrant_box_url => BOX_URL,
    :wf_hostname     => 'client.vm',
  },
}

Vagrant.configure(2) do |config|

  IRODS_HOSTS.each do |name,cfg|
    config.vm.define name do |vm_config|

      vm_config.vm.provider "virtualbox" do |v|
        v.gui = false
      end

      if Vagrant.has_plugin?('landrush')
       vm_config.landrush.enabled = true
       vm_config.landrush.tld = 'vm'
      end

      vm_config.ssh.username  = 'learner'

      vm_config.vm.box      = cfg[:vagrant_box] if cfg[:vagrant_box]
      vm_config.vm.box_url  = cfg[:vagrant_box] if cfg[:vagrant_box_url]
      vm_config.vm.hostname = cfg[:wf_hostname] if cfg[:wf_hostname]

    end
  end


end
