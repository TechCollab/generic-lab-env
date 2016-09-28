# Generic Lab Environment
Template lab environmnet for learning and testing linux based tasks  
Tools Set:
- vagrant 
- virtualbox
- ansible  

## Setup lab host 

Prerequisites: 
- System must be up to date 
- git and ansible must be installed

~~~
$ git clone https://github.com/TechCollab/generic-lab-env.git && cd generic-lab-env
$ sudo ansible-galaxy install --force -r ansible/requirements.yml 
$ ansible-playbook -c localhost ansible/provision_lab_host.yml
~~~

## Provision the lab 
Infa boxes play the role of infrastrucure/support for all lab variants  
To bring them up in the project home dir do 

~~~
$ vagrant up
~~~

All boxes are and should be described in `vagrantvms.yml`. 


# Lab prebuild services

**Service:** DNS Server  
Service FQDN: dns.penguin.example.com  
penguin.example.com.zone  
penguin.example.com.revzone  
        
**Service:** HTTP Repository      

**Service:** NFS Server  
Service FQDN: nfs01.penguin.example.com  
Shares:  
	"/home/ldpusers"  
	"/shared/books"  
	"/shared/docs"   

## Networks  
Vagrant default NAT network   
192.168.55.0/24 penguin.example.com   



