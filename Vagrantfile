# -*- mode: ruby -*-
# vi: set ft=ruby :

infra_hosts = [
  { name: 'latin' , ip: '192.168.55.10' },
  { name: 'crack' , ip: '192.168.55.11' }
]

Vagrant.configure(2) do |config|
  #config.vm.box = "szops/centos-6-x86_64"
  config.vm.box = "relativkreativ/centos-7-minimal"

  infra_hosts.each do |host|
    host_name = host[:name]
    config.vm.define host_name do |node|
      node.vm.hostname = host_name 
      node.vm.network 'private_network', ip: host[:ip]
      node.vm.provision 'ansible' do |ansible|
        ansible.playbook = 'ansible/provision_infra_vms.yml'
      end
    end

    config.vm.provision "ansible" do |ansible|
          # Auto-Generated Inventory is used
          # For details see: https://www.vagrantup.com/docs/provisioning/ansible_intro.html 
          #ansible.inventory_path    = "hosts" 
          ansible.playbook          = "ansible/provision_lab_vm.yml"
          ansible.host_key_checking = "false"
          #ansible.verbose = "v"
    end
  end
end
# -*- mode: ruby -*-
# vi: set ft=ruby :
# RHEL 6 boxes

rhel6_hosts = [
  { name: 'balsa' , ip: '192.168.55.30' },
  { name: 'benny' , ip: '192.168.55.31' }
]

Vagrant.configure(2) do |config|
  config.vm.box = "szops/centos-6-x86_64"


  rhel6_hosts.each do |host|
    host_name = host[:name]
    config.vm.define host_name do |node|
      node.vm.hostname = host_name
      node.vm.network 'private_network', ip: host[:ip]
      #node.vm.provision 'ansible' do |ansible|
      #  ansible.playbook = 'ansible/provision_infra_vms.yml'
      #end
    end
    config.vm.provision "ansible" do |ansible|
      ansible.playbook          = "ansible/provision_lab_vm.yml"
      ansible.host_key_checking = "false"
    end
  end
end
