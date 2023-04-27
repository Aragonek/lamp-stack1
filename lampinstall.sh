#!/bin/bash

yum update -y
yum install epel-release

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

systemctl restart httpd

dnf install vsftpd
rpm -qi vsftpd

systemctl start vsftpd
systemctl enable vsftpd <<EOF

  echo /etc/vsftpd/vsftpd.conf | >> pasv_min_port=30000 pasv_max_port=31000 userlist_file=/etc/vsftpd/user_list userlist_deny=NO
EOF

systemctl restart vsftpd

openssl req -x509 -nodes -days 3650 -newkey rsa:2048 -keyout /etc/vsftpd.pem -out /etc/vsftpd/vsftpd.pem <<EOF
  echo /etc/vsftpd/vsftpd.conf | >> rsa_cert_file=/etc/vsftpd/vsftpd.pem rsa_private_key_file=/etc/vsftpd.pem ssl_enable=ON
EOF

firewall-cmd --add-service=http --permanent
firewall-cmd --add-service=https --permanent
firewall-cmd --add-port=80/tcp --permanent
firewall-cmd --add-port=3306/tcp --permanent
firewall-cmd --add-port=10000/tcp --permanent
firewall-cmd --add-port=443/tcp --permanent
firewall-cmd --add-port=20-21/tcp --permanent
firewall-cmd --add-port=30000-31000/tcp --permanent
systemctl restart firewalld
