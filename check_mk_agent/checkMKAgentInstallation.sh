#!/bin/bash

sudo yum update -y 
# Installing the check_mk agent 
sudo yum install xinetd -y 
tar -xvzf /vagrant/check_mk-1.1.12p7.tar.gz
cd check_mk-1.1.12p7
tar -xvzf agents.tar.gz
touch /etc/xinetd.d/check_mk
sudo cp /vagrant/check_mk /etc/xinetd.d/check_mk
sudo cp check_mk_agent.linux /usr/bin/check_mk_agent
sudo chmod +x /usr/bin/check_mk_agent

# Start
sudo service xinetd stop && sudo service xinetd start
sudo chkconfig xinetd on

