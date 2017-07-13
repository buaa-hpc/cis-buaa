#!/bin/bash
 
#@HEADER
# ***************************************************
#
# CIS: Cluster Installation Script
#
# Contact:
# Liu Quan (liuquan2049@buaa.edu.cn)
#
# ***************************************************
#@HEADER

# ===================================================
#
# 输入密码，配置无密码访问
# ===================================================
# TODO 
#进入其他用户，多个用户的自动配置
#
# ===================================================

node_num=12
root_passwd=root
lq_passwd=liuquan2049

#ssh_keygen ====================================================== 
#生成当前用户的密钥 -q quiet
#--- overwrite?  y
ssh_keygen(){
    expect -c "set timeout -1;
		spawn ssh-keygen -t rsa -P \"\" -f $HOME/.ssh/id_rsa 
		expect {
		    *Overwrite*(y/n)?* {send -- \"y\r\";exp_continue;}
		    eof		{exit 0;}		
		}";
}
#=================================================================

#ssh_copy_id =====================================================
#配置当前用户无密码访问hosts中其他节点
#--- $1 ---当前用户密码
ssh_copy_id(){
for i in $(seq   1  $node_num)
do
node_id=$i
    expect -c "set timeout -1; 
                spawn ssh-copy-id $1@gpu$node_id;
                expect {
                    *(yes/no)* {send -- yes\r;exp_continue;}
                    *password:* {send -- $2\r;exp_continue;}
                    eof        {exit 0;}
                }";

done
echo -e "\033[32m ------------  $USER@`hostname` 对其他主机无密码访问配置 完成！------------  \033[0m"
sleep 1
}
#=================================================================

rm ~/.ssh/known_hosts
  echo -e "\033[32m $USER@`hostname` 开始生成用户密钥  ...  \033[0m"
  sleep 1
ssh_keygen 
  echo -e "\033[32m $USER@`hostname` 开始配置无密码访问 ...  \033[0m"
  sleep 1
ssh_copy_id root $root_passwd
ssh_copy_id lq $lq_passwd
#
#
