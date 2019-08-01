#!/usr/bin/env bash
#
#author:SwordsDevil
#date:2019/07/29
#usage: initial server
#modify:@date


systemctl stop firewalld && systemctl disable firewalld
sed -ri s/SELINUX=enforcing/SELINUX=disabled/g /etc/selinux/config
setenforce 0

mkdir /tasks
echo "* * */7 * * bash /tasks/ntpSync.sh" >>/var/spool/cron/$(whoami)
cat <<-EOF >/tasks/ntpSync.sh
#!/usr/bin/env bash
#
#author:SwordsDevil
#date:2019/07/30
#usage:sync system time

if [ ! -f /usr/bin/ntpdate ];then
	yum -y install ntpdate
	ntpdate -b ntp1.aliyun.com &
else
	ntpdate -b ntp1.aliyun.com &
fi
EOF

echo "export HISTSIZE=10000" >>/etc/profile
echo "export HISTTIMEFORMAT=\"%Y-%m-%d-%H:%M:%S - \"" >>/etc/profile
source /etc/profile


yum -y install vim bash-completion net-tools wget

if [ $? -eq 0 ];then
	exit 0
else
	exit 1234
fi 

