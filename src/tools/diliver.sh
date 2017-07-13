#!/bin/bash

cis_root=/root/cis/

for i in $(seq  1 $NODE_NUMS)
do
   scp -r $cis_root  gpu$i:/root/
   scp -r $cis_root gpu$i:/home/lq
   echo i=$i-------------------------------------------
done
