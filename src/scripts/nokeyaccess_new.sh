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

NODE_NUMS=3
ROOT_PASSWD=root
USER_PASSWD=lq

# ===================================================
#ssh_keygen  生成当前用户的密钥 -q quiet
#--- overwrite?  y
ssh_keygen()
{
    expect -c "set timeout -1;
		spawn ssh-keygen -t rsa -P \"\" -f $HOME/.ssh/id_rsa 
		expect {
		    *Overwrite*(y/n)?* {send -- \"y\r\";exp_continue;}
		    eof		{exit 0;}		
		}";
}

# ssh_keygen_all 生成所有用户密钥，包括lq@gpu1
# --- $1 --- 用户名
ssh_keygen_all()
{
for i in $(seq 1 $NODE_NUMS)
do
	if [ $i != 1 -o $1 != "root" ];then
	    ssh $1@gpu$i "ssh-keygen -t rsa -P \"\" -f ~/.ssh/id_rsa "
	else 
	echo 23333333333333333333333333333333333333333333333333333333333333
	fi
done
}



# ssh_copy_id 配置当前用户无密码访问hosts中其他节点
# --- $1 --- 当前用户名
# --- $2 --- 当前用户密码
ssh_copy_id()
{
for i in $(seq 1 $NODE_NUMS)
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
sleep 1
}





# scp_pub 将其他用户公钥复制到gpu1
# --- $1 --- 用户名
scp_pub()
{
for i in $(seq 1 $NODE_NUMS)
do
	scp $1@gpu$i:~/.ssh/id_rsa.pub tmp
   	cat tmp >> /root/.ssh/authorized_keys
done

rm -f tmp
}

# scp_aukeys 将已认证公钥复制到其他机器
scp_aukeys()
{
for i in $(seq 1 $NODE_NUMS)
do
	scp /root/.ssh/authorized_keys $1@gpu$i:~/.ssh/authorized_keys
	scp /root/.ssh/known_hosts     $1@gpu$i:~/.ssh/known_hosts
done
}

#=================================================================

# main

rm ~/.ssh/known_hosts

echo -e "\033[32m 开始生成用户密钥  ...  \033[0m"
sleep 1
ssh_keygen
echo -e "\033[32m 用户密钥生成 完成！  \033[0m"
sleep 1
echo 
echo -e "\033[32m 开始配置无密码访问 ...  \033[0m"
sleep 1
ssh_copy_id root $ROOT_PASSWD
ssh_copy_id lq   $USER_PASSWD
echo -e "\033[32m 对其他主机无密码访问配置 完成！ \033[0m"
sleep 1
echo 
echo -e "\033[32m 开始生成其他主机用户密钥  ...  \033[0m"
sleep 1
ssh_keygen_all root
ssh_keygen_all lq
echo -e "\033[32m 其他主机用户密钥生成 完成! \033[0m"
sleep 1

for i in $(seq  2 $NODE_NUMS)
do
   scp    /etc/hosts gpu$i:/etc/hosts 
done

echo 
echo -e "\033[32m 开始加入其他主机公钥  ...  \033[0m"
sleep 1
scp_pub root
scp_pub lq
echo -e "\033[32m 加入其他主机公钥 完成！  \033[0m"
sleep 1
echo 
echo -e "\033[32m 开始分发可用的认证公钥  ...  \033[0m"
sleep 1
scp_aukeys root
scp_aukeys lq
echo -e "\033[32m 可用的认证密钥分发 完成！  ...  \033[0m"
sleep 1
echo 
echo -e "\033[32m 集群无密码访问配置完成  \033[0m"
sleep 1
