#!/bin/bash

#注未添加passwd 默认已经支持无密码访
cis_root=/root/cis/
cis_file=$cis_root/file/
cis_scripts=$cis_root/scripts/
nokeyaccess_auto=nokeyaccess_auto.sh
user=root

ssh_and_rm(){
ssh $1@mic$2 << remotessh
cd $cis_scripts
chmod 777 ./*
rm -rf /root/cis/
exit
remotessh


}

for i in $(seq 1 12 );do
  if [ $i -ne 1 ];then	
    	ssh_and_rm $user $i 
	echo $i -----------------
  else
	echo 不删除本地
  fi
done
