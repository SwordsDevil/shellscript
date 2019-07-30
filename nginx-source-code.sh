#!/usr/bin/env bash
#
#author:SwordsDevil
#date:2019/07/30
#useage:nginx source code install
#modify:@date


yum -y install wget
wget http://nginx.org/download/nginx-1.17.2.tar.gz -O /opt/nginx-1.17.2.tar.gz
tar xf /opt/nginx-1.17.2.tar.gz -C /opt/
yum -y install pcre-devel zlib-devel
useradd -M -s /sbin/nologin nginx
cd /opt/nginx-1.17.2
./configure --prefix=/usr/local/nginx/ --user=nginx --group=nginx
echo $?
make -j 2
echo $?
make install
echo $?
systemctl stop firewalld
systemctl disable firewalld
setenforce 0
cd /usr/local/nginx/sbin/
./nginx
