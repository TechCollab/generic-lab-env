

Networks:
Vagrant default NAT network 
192.168.55.10/24 penguin.example.com 


Multi Purpose Server 1 (latin):

  DNS Server
	dns.penguin.example.com
        "/var/named/penguin.example.com.zone"
        "/var/named/penguin.example.com.revzone"
   
  HTTP Repository  

Multi Purpose Server 2 (crack):    

  NFS Server  
        nfs01.penguin.example.com 
	share:
		"/home/ldpusers"
		"/shared/books" 
		"/shared/docs" 

  LDAP Server
        ldp01.penguin.example.com 
        	Users: ldppage, ldpdrum, ldpmary		(UID=31***)
        	cert: ldp01.penguin.example.com:/etc/openldap/certs/cert.pem

