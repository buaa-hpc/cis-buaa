#!/bin/bash

#注未添加passwd 默认已经支持无密码访
cis_root=/root/cis/
cis_file=$cis_root/file/
cis_scripts=$cis_root/scripts/
cis_tools=$cis_root/tools

passwd_lq=lq

export NODE_NUMS=3


ssh_and_act(){
ssh $1@gpu$2  << remotessh1

chown -R lq:lq /home/lq/cis/
sh $cis_scripts/main.sh

echo =============================
echo 
echo
remotessh1


#expect -c "
#	set timeout 1;
#	spawn ssh $1@gpu$2
#	expect {
#        	*(yes/no)?* {send \"yes\r\";exp_continue}	
#		}
#	expect *# {send \"echo success login gpu$2==========\r\"}
#	expect *# {send \"echo success excude!\r\"}
#        expect eof"
#
}


yum install expect tcl -y
#sh ./nokeyaccess_auto.sh 

cp -r  ../../cis /root/cis
sh ./diliver.sh

for i in $(seq  1 $NODE_NUMS );do
  if [ $i -eq 1 ];then	
  	sh $cis_scripts/main.sh
  else
    	ssh_and_act root  $i
  fi

  # lq用户无密码访问
  
  #ssh lq@gpu$i  << remotessh2

 # sh /home/lq/cis/scripts/nokeyaccess_auto.sh

#remotessh2

sync
  
done
