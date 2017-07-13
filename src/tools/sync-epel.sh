#!/bin/sh
#
# reposync
#

BASEDIR=/var/www/html/centos/7
mkdir -p $BASEDIR 
cd $BASEDIR

reposync -n -r epel
repomanage -o -c epel | xargs rm -fv
createrepo epel
