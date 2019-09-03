#!/usr/bin/env bash
#
#date:2019/09/02
#usage: expect auto ssh client

if [ ! -f $HOME/.ssh/id_rsa ];then
  ssh-keygen -t rsa -f $HOME/.ssh/id_rsa -q -N ""
fi

user="root"
password="1"
for ips in $(cat ips.txt);do
  /usr/bin/expect <<-EOF
    spawn ssh-copy-id $user@${ips}
    expect "yes/no" { send "yes\r" }
    expect "*password*" { send "$password\r" }
    expect eof
EOF
wait
done
