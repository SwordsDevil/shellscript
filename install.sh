#!/usr/bin/env bash
#
#author:SwordsDevil
#date:2019/07/31
#usage:auto deploy mysql tarball.


MPATH="/usr/local/mysqld"

id mysql &>/dev/null
if [ $? -ne 0 ];then
	useradd -M -s /sbin/nologin mysql
fi
chown -R mysql:mysql /usr/local/mysqld

if [ -f /etc/my.cnf ];then
	mv /etc/my.cnf{,.bak}
fi
cp ${MPATH}/mysql/mysql-test/include/default_my.cnf /etc/my.cnf

echo 'export PATH=$PATH:/usr/local/mysqld/mysql/bin' >>/etc/profile

if [ ! -f /etc/init.d/mysqld ];then
	cp ${MPATH}/mysql/support-files/mysql.server /etc/init.d/mysqld
	chkconfig --all mysqld && chkconfig mysqld on
	ln -s ${MPATH}/mysql/support-files/mysql.server /usr/bin/mysqlctl
fi

ps aux | grep mysql | grep -v grep &>/dev/null
if [ $? -ne 0 ];then
	mysqlctl start
	ln -s /usr/local/mysqld/tmp/mysql.sock /tmp/mysql.sock
fi

word=$(grep "temporary password" ${MPATH}/log/mysql_error.log)
passwd=${word##*" "}

echo "Thank for you using bavduer's tools"
echo
echo "Email: 274262321@qq.com"
echo "Github: https://github.com/SwordsDevil"
echo
echo
echo "User: root"
echo "Password: ${passwd}"
echo "your first run command: source /etc/profile"
echo "Please update password, use ALTER USER root@localhost IDENTIFIED BY userPassword;"
echo
echo "Complete ^_~"
