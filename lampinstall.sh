#!/bin/bash

dnf update -y

dnf install epel-release
dnf install -y https://rpms.remirepo.net/enterprise/remi-release-8.rpm

dnf install httpd -y
systemctl start httpd
systemctl enable httpd

dnf install mariadb-server mariadb -y

systemctl start mariadb
systemctl enable mariadb

mysql_secure_installation <<EOF

y
Kode1234!
Kode1234!
n
n
n
n
EOF

dnf install php php-mysqlnd php-json php-gd php-mbstring -y

cat << EOF > /etc/yum.repos.d/webmin.repo
[Webmin]
name=Webmin  
mirrorlist=https://download.webmin.com/download/yum/mirrorlist
enabled=1
gpgkey=http://www.webmin.com/jcameron-key.asc
EOF

dnf update -y
dnf install webmin -y

systemctl start webmin
systemctl enable webmin

dnf module enable php:remi-7.4
dnf --enablerepo=remi install phpMyAdmin -y

systemctl restart httpd

dnf install vsftpd
rpm -qi vsftpd

systemctl start vsftpd
systemctl enable vsftpd 

firewall-cmd --add-port=80/tcp --permanent
firewall-cmd --add-port=3306/tcp --permanent
firewall-cmd --add-port=10000/tcp --permanent
firewall-cmd --add-port=443/tcp --permanent
firewall-cmd --add-port=20-21/tcp --permanent
firewall-cmd --add-port=30000-31000/tcp --permanent
firewall-cmd --add-port=587/tcp --permanent
semanage port -a -t http_port_t -p tcp 80
systemctl restart firewalld
