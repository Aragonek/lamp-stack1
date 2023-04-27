#!/bin/bash

yum update -y

yum install httpd -y
systemctl start httpd
systemctl enable httpd

yum install mariadb-server mariadb -y

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

yum install php php-mysqlnd php-json php-gd php-mbstring -y
systemctl restart httpd
firewall-cmd --add-service=http --permanent
firewall-cmd --add-service=https --permanent
firewall-cmd --add-port=80/tcp --permanent
firewall-cmd --add-port=3306/tcp --permanent

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
firewall-cmd --add-port=10000/tcp --permanent
