#!/bin/bash

# 用root权限登录  修改2-12台机器的lq密码
for i in $(seq 2 12)
do

ssh mic$i << remotessh

fuser -k /home/asc
fuser -k /home/lq
mv  /home/asc /home/lq
usermod -l lq -d /home/lq -m asc
groupmod -n lq asc 

(echo "liuquan2049"
echo "liuquan2049") | passwd  lq
echo -e "\033[32m  $USER@mic$i 密码替换成功\r  \033[0m"

remotessh

done
