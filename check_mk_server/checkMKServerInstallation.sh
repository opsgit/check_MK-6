#!/bin/bash

#  Install Packages on Monitoring Server
sudo rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
sudo rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
sudo yum -y install nagios nagios-plugins-all nagios-plugins-nrpe nrpe php httpd
sudo chkconfig httpd on && chkconfig nagios on
sudo mkdir -p /var/run/nagios/
sudo service httpd start && service nagios start

# We should also enable SWAP memory on this droplet, at least 2GB:
Swap=`free -m|awk '{print $1}'|tail -1|cut -d ":" -f1`
if [ ${Swap} == "Swap" ] ; then
  echo "Swap partition available ..."
else
  sudo dd if=/dev/zero of=/swap bs=1024 count=2097152
  sudo mkswap /swap && chown root. /swap && chmod 0600 /swap && swapon /swap
  echo /swap swap swap defaults 0 0 >> /etc/fstab
  echo vm.swappiness = 0 >> /etc/sysctl.conf && sysctl -p
fi

# Set Password Protection
sudo htpasswd -b -c /etc/nagios/passwd nagiosadmin nagios

# Internal services that are listening on localhost, such as MySQL, memcached, system services, we will need to use NRPE. Install NRPE on Clients
sudo rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
sudo rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
sudo yum -y install nagios nagios-plugins-all nrpe
chkconfig nrpe on

touch /etc/nagios/nrpe.cfg
cp /vagrant/nrpe.cfg /etc/nagios/nrpe.cfg
# Start NRPE on all of your client hosts:
service nrpe start

# Add Server Configurations on Monitoring Server, Back on our Monitoring server, we will have to create config files for each of our client servers:
echo "cfg_dir=/etc/nagios/servers" >> /etc/nagios/nagios.cfg
mkdir /etc/nagios/servers && cd /etc/nagios/servers && touch check_mk_server.cfg && cd -
# After you are done adding all the client configurations, you should set folder permissions correctly and restart Nagios on your Monitoring Server:
sudo chown -R nagios. /etc/nagios
sudo mkdir /var/log/nagios/rw
sudo service nagios restart

# Install xinetd
sudo yum install -y xinetd

# Installing the OMD Package
sudo yum install --nogpgcheck omd-0.42-0.42-centos55.14.x86_64.rpm
# centos 6.7
sudo chmod 777 /vagrant/omd-1.10-rh61-31.x86_64.rpm
sudo yum localinstall /vagrant/omd-1.10-rh61-31.x86_64.rpm -y

# Creating first OMD site, OMD Sites are completely independent instances of OMD. You can have several sites on your OMD host, for example one for production use, one for configuration tests, and one for upgrade tests. Creating your first OMD site is very easy. You just have to choose a site name, say prod. Then, as root user, you simply type
omd create prod

# A site user and group prod is created, as well as a home directory for the user in /omd/sites/prod. You should now switch to that user and start the site (even though sites can be started and maintained as the root user as well).
su prod -c "omd start && echo 'omd started ...'"
