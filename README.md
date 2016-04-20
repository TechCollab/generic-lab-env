# Generic Test Lab
Template lab environmnet for learning and testing linux based tasks

## Setup

~~~bash
git clone https://github.com/bboykov/generic_test_lab.git
cd generic_test_lab;bash scripts/bootstrap_and_setup_host.sh $PWD
~~~

## TODO

* Modify "scripts/bootstrap_and_setup_host.sh" to not use passwordless ssh to localhost  
There is one host that Ansible automatically adds to the inventory by default: localhost.   
Ansible understands that localhost refers to your local machine,   
so it will interact with it directly rather than connecting by SSH   
