#!/bin/bash

read -p "Please input an command:" cmd

cmd

for i in $(seq 2 12)
do
  if [!ping -c  1 -W 1 mic$i &> /dev/null];then
    echo -e "Server mic$i is \033[31m DOWN \033[0m"
  else
    echo -ne "\n"
    echo -e "Server mic$i is running the command \033[32m $cmd \033[0m"
    ssh mic$i "$cmd"
    echo "Success"
  fi
done
