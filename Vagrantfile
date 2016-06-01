# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  #config.vm.box = "szops/centos-6-x86_64"
  config.vm.box = "relativkreativ/centos-7-minimal"

  config.vm.define :latin do |latin|
    latin.vm.hostname = "latin"
    latin.vm.network :private_network, ip: "192.168.55.10"
  end

  config.vm.define :crack do |crack|
    crack.vm.hostname = "crack"
    crack.vm.network :private_network, ip: "192.168.55.11"

    #crack.vm.provision "ansible" do |ansible|
      # Auto-Generated Inventory is used
      # For details see: https://www.vagrantup.com/docs/provisioning/ansible_intro.html 
      #ansible.inventory_path    = "hosts" 
      #ansible.playbook          = "ansible/provision_vm22.yml"
      #ansible.host_key_checking = "false"
      #ansible.verbose = "v"
    #end
  end

  config.vm.provision "ansible" do |ansible|
      # Auto-Generated Inventory is used
      # For details see: https://www.vagrantup.com/docs/provisioning/ansible_intro.html 
      #ansible.inventory_path    = "hosts" 
      ansible.playbook          = "ansible/provision_lab_vm.yml"
      ansible.host_key_checking = "false"
      ansible.verbose = "v"
    end
end
# -*- mode: ruby -*-
# vi: set ft=ruby :
# Test subjects

Vagrant.configure(2) do |config|
  config.vm.box = "szops/centos-6-x86_64"

  config.vm.define :balsa do |balsa|
    balsa.vm.hostname = "balsa"
    balsa.vm.network :private_network, ip: "192.168.55.30"
  end

  config.vm.define :benny do |benny|
    benny.vm.hostname = "benny"
    benny.vm.network :private_network, ip: "192.168.55.31"
  end

  config.vm.provision "ansible" do |ansible|
      ansible.playbook          = "ansible/provision_lab_vm.yml"
      ansible.host_key_checking = "false"
    end
end
