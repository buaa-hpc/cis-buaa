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


cis_dir=/root/cis/
cis_file=$cis_dir/file/
cis_scripts=$cis_dir/scripts/

passwd_root=root



cd $cis_scripts

sh $cis_scripts/service_disable.sh
sh $cis_scripts/yum_local_setup.sh
sh $cis_scripts/expect_install.sh
sh $cis_scripts/nfs_mount.sh
#sh $cis_scripts/nokeyaccess_auto.sh
sh $cis_scripts/ib_cofig.sh

