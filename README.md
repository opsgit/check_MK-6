## POC on Monitoring tool Check_MK

#### Official website
http://mathias-kettner.com/check_mk.html

#### Official documentation (Wiki)
https://mathias-kettner.de/checkmk.html

#### Procedure : Getting Started 
We assume that you have setup vagrant correctly and its working fine.

##### Clone the repo
```bash
git clone https://github.com/OpsTree/check_MK
```
##### Change working directory
```bash
cd check_MK/check_mk_server
```
##### Download omd package
```bash
wget http://files.omdistro.org/releases/centos_rhel/omd-1.10-rh61-31.x86_64.rpm
```
##### Provision vagrant box
```bash
vagrant up
```
##### Omd admin panel
```bash
http://192.168.33.10/prod/
username = omdadmin
password = omd

