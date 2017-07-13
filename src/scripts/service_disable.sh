#!/bin/bash

cis_file=/root/cis/file


systemctl disable firewalld
systemctl stop firewalld

mv /etc/selinux/config /etc/selinux/config.bak
cp $cis_file/selinux /etc/selinux/config
setenforce 0
