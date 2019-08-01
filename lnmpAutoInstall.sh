#!/usr/bin/env bash
#
#author : SwordsDevil
#date: 2019/08/01
#usage: lnmp auto install
#modify:@date


cat <<-EOF >/etc/yum.repos.d/nginx.repo
[nginx-stable]
name=nginx stable repo
baseurl=http://nginx.org/packages/centos/\$releasever/\$basearch/
gpgcheck=1
enabled=1
gpgkey=https://nginx.org/keys/nginx_signing.key  
EOF

if [ ! -f /etc/yum.repos.d/epel.repo ];then
	yum -y install epel-release
fi

yum -y install nginx mariadb-server mariadb php php-gd php-mcrypt php-mbstring php-devel php-mysql php-xml php-fpm

systemctl start nginx mariadb php-fpm
systemctl enable nginx mariadb php-fpm

if [ -f /etc/nginx/conf.d/default.conf ];then
	mv /etc/nginx/conf.d/default.conf{,.bak}
fi
cat <<-EOF >/etc/nginx/conf.d/default.conf
 server {       
    listen       80;
    server_name  www.pycompute.com;  

    charset koi8-r;
    access_log  /var/log/nginx/pycompute.access.log  main;

    location / { 
        root   /usr/share/nginx/html;  
        index  index.php index.html index.htm; 
    }


    location ~ \.php$ {
        root           /usr/share/nginx/html;
        fastcgi_pass   127.0.0.1:9000;
        fastcgi_index  index.php;
        fastcgi_param  SCRIPT_FILENAME  \$document_root\$fastcgi_script_name;
        include        fastcgi_params;
    }
} 
EOF

systemctl restart nginx

mysql -uroot -e "grant all privileges on *.* to cwb@localhost identified by '123456';"

cat <<-EOF >/usr/share/nginx/html/index.php
<?php
\$link = mysql_connect('localhost', 'cwb', '123456');
if (!\$link) {
    die('Could not connect: ' . mysql_error());
}
echo 'Connected successfully';
mysql_close(\$link);
?>
EOF

