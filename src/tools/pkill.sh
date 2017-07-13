#!/bin/bash

#未添加passwd 默认已经支持无密码访
cis_root=/root/cis/
cis_file=$cis_root/file/
cis_scripts=$cis_root/scripts/
nokeyaccess_auto=nokeyaccess_auto.sh
user=root

ssh_and_act(){
ssh $1@mic$2 << remotessh
pkill -9 xhpcg 

exit
remotessh
}

for i in $(seq 1 12 );do
    	ssh_and_act $user $i 
done
