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

# TODO


cis_dir=/root/cis/
cis_file=$cis_dir/file

nfs_dir=/home/cluster/
host_name=`hostname`
server_name=gpu1

#客户端 服务端 设置不同


#服务端
if [ "$host_name" == "gpu1" ];then
  umount /home/cluster
  umount /home/cluster
  umount /home/cluster
  

  echo -e "\033[32m 服务端 NFS搭建 ...  \033[0m"
  yum install rpcbind nfs-utils -y #@@ TODO 安装成功状态检测
  rm  /etc/exports
  echo cp $cis_file/exports /etc/exports
  cp $cis_file/exports /etc/exports

  echo mkdir $nfs_dir
  mkdir $nfs_dir
  echo chown -R lq:lq $nfs_dir
  chown -R lq:lq $nfs_dir
  echo chmod 777 $nfs_dir
  chmod 777 $nfs_dir
 
  # 挂载到tmpfs上
  #mount -t tmpfs -o size=128G tmpfs /home/cluster  
  #echo mount -t tmpfs -o size=128G tmpfs /home/cluster  
  

  # rpcbind  nfs服务启动
  echo systemctl restart rpcbind
  systemctl restart rpcbind
  echo systemctl enable rpcbind
  systemctl enable rpcbind
  echo systemctl restart nfs
  systemctl restart nfs
  echo systemctl enable nfs  # rpcbind nfs 状态判断 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  systemctl enable nfs  # rpcbind nfs 状态判断 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  
  echo -e "\033[32m 服务端NFS搭建  完成！  \033[0m"
#客户端
else
  echo -e "\033[32m $host_name 客户端NFS的搭建 ... \033[0m"
  #卸载
  umount $nfs_dir

  yum install rpcbind nfs-utils -y #安装成功状态检测 @@@@@@@@@@@@@@@@@@@@@@@@
  
  echo mkdir $nfs_dir
  mkdir $nfs_dir
  echo chown -R lq:lq $nfs_dir
  chown -R lq:lq $nfs_dir
  
  echo systemctl restart rpcbind
  systemctl restart rpcbind
  echo systemctl enable rpcbind
  systemctl enable rpcbind
  echo systemctl restart nfs
  systemctl restart nfs
  echo systemctl enable nfs  # rpcbind nfs 状态判断 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  systemctl enable nfs  # rpcbind nfs 状态判断 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

  #挂载  先不挂载 重启后挂载
  #mount $server_name:$nfs_dir $nfs_dir

  echo -e "\033[32m $host_name 客户端NFS的搭建 完成! \033[0m"
fi
