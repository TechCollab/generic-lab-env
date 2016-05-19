# Generic Test Lab
Template lab environmnet for learning and testing linux based tasks  
Tools Used to build:
- vagrant  
- ansible  
- virtualbox  

## Setup lab host (Installing vagrant with virtualbox provider)
To setup freshly installed copy of CentOS 7 clone the repo and run the below.

Prerequisites: 
- System to be latest
- git and ansible must be installed

~~~bash
$ git clone https://github.com/bboykov/generic_test_lab.git
$ cd generic_test_lab && sudo bash scripts/install_prereqs.sh
$ sudo ansible-galaxy install --force -r requirements.yml
$ # Make sure to update your system to latest before running provision_lab_host.yml
$ ansible-playbook  provision_lab_host.yml 
~~~


# Lab infra overview
## Infra VMs - latin and crack
Infa boxes play the role of infrastrucure/support for all lab variants  
To bring them up in the repo root dir do `vagrant up`  

### Multi Purpose Server 1 (latin)  
**Service:** DNS Server  
Service FQDN: dns.penguin.example.com
penguin.example.com.zone  
penguin.example.com.revzone  
        
**Service:** HTTP Repository    

### Multi Purpose Server 2 (crack)      
**Service:** NFS Server  
Service FQDN: nfs01.penguin.example.com  
Shares:  
	"/home/ldpusers"  
	"/shared/books"  
	"/shared/docs"   

## Networks  
Vagrant default NAT network   
192.168.55.0/24 penguin.example.com   

## Services


