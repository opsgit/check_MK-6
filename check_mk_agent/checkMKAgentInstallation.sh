#!/bin/bash

# #
sudo yum update -y 
# Installing the check_mk agent 
sudo yum install -y check-mk-agent

# create check_mk under /etc/xinetd.d
sudo mkdir -p /etc/xinetd.d
touch /etc/xinetd.d/check_mk
cp /vagrant/check_mk /etc/xinetd.d/check_mk

# Restart 
/etc/init.d/xinetd restart
chkconfig xinetd on
