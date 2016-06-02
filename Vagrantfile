# How it works:
# See http://blog.scottlowe.org/2014/10/22/multi-machine-vagrant-with-yaml/ for details.
# -*- mode: ruby -*-
# # vi: set ft=ruby :
 
# Specify minimum Vagrant version and Vagrant API version
Vagrant.require_version ">= 1.6.0"
VAGRANTFILE_API_VERSION = "2"
 
# Require YAML module
require 'yaml'
 
# Read YAML file with box details
vagrantvms = YAML.load_file('vagrantvms.yml')
 
# Create boxes
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # Use the same key for each machine
  config.ssh.insert_key = false
 
  # Iterate through entries in YAML file
  vagrantvms.each do |vagrantvms|
    config.vm.define vagrantvms["name"] do |srv|
      srv.vm.box = vagrantvms["box"]
      srv.vm.network "private_network", ip: vagrantvms["ip"]
      srv.vm.provider :virtualbox do |vb|
        vb.name = vagrantvms["name"]
        vb.memory = vagrantvms["ram"]
      end
    end
  end

  config.vm.provision "ansible" do |ansible|
    ansible.playbook          = "ansible/site.yml"
    ansible.host_key_checking = "false"
    #ansible.verbose           = "v"
  end
end
