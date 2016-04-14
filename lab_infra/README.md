# lab_infra desc.  
This vagrant setup will play the role of infrastrucure/support for all lab variants  

# Networks  
Vagrant default NAT network   
192.168.55.10/24 penguin.example.com   


## Multi Purpose Server 1 (latin)  
Service: DNS Server
dns.penguin.example.com:  
penguin.example.com.zone  
penguin.example.com.revzone  
        
Service: HTTP Repository    

## Multi Purpose Server 2 (crack)      
Service: NFS Server  
service fqdn: nfs01.penguin.example.com  
shares:
	"/home/ldpusers"  
	"/shared/books"  
	"/shared/docs"   

