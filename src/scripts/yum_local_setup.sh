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

#========
#  TODO
#========
#   服务端代码



cis_root=/root/cis/
cis_file=$cis_root/file
cis_scripts=$cis_root/scripts
host_name=`hostname`


#mv /etc/hosts /etc/hosts.bak
#cp $cis_file/hosts /etc/hosts


if [ "$host_name" = "gpu1" ] ;then
#服务端
  echo -e "\033[32m 服务端yum,epel源配置 ... \033[0m"
  echo cp -r /etc/yum.repos.d /etc/yum.repos.d.bak
  cp -r /etc/yum.repos.d /etc/yum.repos.d.bak
  echo cd  /etc/yum.repos.d
  cd /etc/yum.repos.d
  echo rm -f ./*
  rm -f ./*

  #repo文件 
  echo cp $cis_file/CentOS-Server.repo /etc/yum.repos.d/
  cp $cis_file/CentOS-Server.repo /etc/yum.repos.d/
  echo cp $cis_file/epel-Server.repo /etc/yum.repos.d/
  cp $cis_file/epel-Server.repo /etc/yum.repos.d/
  yum clean all
  yum makecache


  #vsftp安装
  yum install vsftpd -y
  echo 正在修改 vsftpd.conf 文件
  echo anon_root=/yum/ >>  /etc/vsftpd/vsftpd.conf 
  systemctl enable vsftpd
  echo systemctl enable vsftpd
  systemctl restart vsftpd
  echo systemctl restart vsftpd
  

  echo -e "\033[32m 服务端yum,epel源配置，局域网服务器配置  完成！ \033[0m"

##安装vstcp并配置
 
else
#客户端

  echo -e "\033[32m $host_name 客户端yum,epel源配置 ...  \033[0m"
  echo cp -r /etc/yum.repos.d /etc/yum.repos.d.bak
  cp -r /etc/yum.repos.d /etc/yum.repos.d.bak
  echo cd  /etc/yum.repos.d
  cd /etc/yum.repos.d
  echo rm -f ./*
  rm -f ./*

  #repo文件
  echo cp $cis_file/CentOS-Client.repo /etc/yum.repos.d/
  cp $cis_file/CentOS-Client.repo /etc/yum.repos.d/
  echo cp $cis_file/epel-Client.repo /etc/yum.repos.d/
  cp $cis_file/epel-Client.repo /etc/yum.repos.d/
  yum clean all
  yum makecache
  echo -e "\033[32m $host_name 客户端yum,epel源配置 完成！  \033[0m"
fi

