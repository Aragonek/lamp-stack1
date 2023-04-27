in MariaDB on the database server
GRANT ALL ON *.* TO 'root'@'x.x.x.x' IDENTIFIED BY 'Kode1234!';

vsftpd config part 1
nano /etc/vsftpd/vsftpd.conf
remove # from chroot_local_user=YES
add pasv_min_port=30000
add pasv_max_port=31000
add userlist_file=/etc/vsftpd/user_list
add userlist_deny=NO
exit and run systemctl restart vsftpd

SSL config
run openssl req -x509 -nodes -days 3650 -newkey rsa:2048 -keyout /etc/vsftpd.pem -out /etc/vsftpd/vsftpd.pem

vsftpd config part 2
nano /etc/vsftpd/vsftpd.conf
add rsa_cert_file=/etc/vsftpd/vsftpd.pem
add rsa_private_key_file=/etc/vsftpd.pem
add ssl_enable=ON
exit and run systemctl restart vsftpd
