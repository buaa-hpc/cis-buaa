#!/bin/bash

#注未添加passwd 默认已经支持无密码访
cis_root=/root/cis/
cis_file=$cis_root/file/
cis_scripts=$cis_root/scripts/
nokeyaccess_auto=nokeyaccess_auto.sh
user=root

ssh_stopfirewalld(){
ssh $1@mic$2 << remotessh
systemctl disable firewalld
echo systemctl disable firewalld
systemctl stop firewalld
echo systemctl stop firewalld

exit
remotessh
}



for i in $(seq 1 12 );do
    	ssh_stopfirewalld $user $i 
done
