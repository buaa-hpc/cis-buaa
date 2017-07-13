#!/bin/bash

export NODE_NUMS=3

for i in $(seq 2 $NODE_NUMS )
do



#初始化用户文件
ssh root@gpu$i  << remotessh1
   
  yum remove tcl expect screen tree iperf  tk rpcbind nfs-utils ntfs-3g  vsftpd -y
  rm -rf /etc/yum.repos.d/
  mv /etc/yum.repos.d.bak /etc/yum.repos.d
  rm -rf /etc/yum.repos.d/yum.repos.d*

  mv /root/.bashrc /root/.bashrc.bak
  mv /home/lq/.bashrc /home/lq/.bashrc.bak
  mv /etc/profile /etc/profile.bak
  mv /etc/hosts /etc/hosts.bak 
 
sleep 1

remotessh1

# 初始化 profile bashrc
scp /root/.bashrc.bak root@gpu$i:/root/.bashrc
scp /home/lq/.bashrc.bak root@gpu$i:/home/lq/.bashrc
scp /etc/profile.bak root@gpu$i:/etc/profile
scp /etc/hosts.bak root@gpu$i:/etc/hosts
scp -r /etc/yum.repos.d.bak root@gpu$i:/etc/yum.repos.d

ssh root@gpu$i << remotessh2

  rm -rf /etc/exports
  rm -rf /root/.ssh
  rm -rf /root/*
  rm -rf /home/lq/*
  rm -rf /home/lq/.ssh

remotessh2

echo -e "\033[32m  gpu$i  初始化完成 ...  \033[0m"

done
