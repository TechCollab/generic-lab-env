# Generic Test Lab
Template lab environmnet for learning and testing linux based tasks

~~~bash
wget https://raw.githubusercontent.com/bboykov/generic_test_lab/master/scripts/bootstrap_and_setup_host.sh
bash bootstrap_and_setup_host.sh
~~~

## Setup

~~~bash
git clone https://github.com/bboykov/generic_test_lab.git
cd generic_test_lab.git/scripts
bash bootstrap_and_setup_host.sh
ansible-playbook -i "ansible/hosts" "$_WORKDIR/ansible/playbooks/provision_virtualbox.yml"
ansible-galaxy install -r requirements.yml
~~~
