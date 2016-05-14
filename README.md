# Generic Test Lab
Template lab environmnet for learning and testing linux based tasks  
Tools Used to build
- vagrant  
- ansible  
- virtualbox  

## Setup CentOS 7 lab host (Installs virtualbox, vagrant and ansible)
To setup freshly installed copy of CentOS 7 clone the repo and run the bootstrap script with root. 

~~~bash
# git clone https://github.com/bboykov/generic_test_lab.git
# cd generic_test_lab;bash scripts/bootstrap_and_setup_host.sh $PWD
~~~

## Setup lab without bootstraping the host
If you already have working environment with virtualbox, vagrant and ansible you can just install required ansible roles

~~~bash
$ git clone https://github.com/bboykov/generic_test_lab.git
$ cd generic_test_lab
$ sudo ansible-galaxy install --force -r playbooks/requirements.yml
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


