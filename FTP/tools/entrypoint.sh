#!/bin/sh

echo "Creating user $FTP_USER"
addgroup -g 433 -S $FTP_USER
adduser -u 431 -D -G $FTP_USER -h /home/$FTP_USER -s /bin/false  $FTP_USER
echo "$FTP_USER:$FTP_PASSWORD" | /usr/sbin/chpasswd
chown $FTP_USER:$FTP_USER /home/$FTP_USER/ -R

echo "" >> /etc/vsftpd/vsftpd.conf
echo "pasv_min_port=$FTP_PASV_MIN_PORT" >> /etc/vsftpd/vsftpd.conf
echo "pasv_max_port=$FTP_PASV_MAX_PORT" >> /etc/vsftpd/vsftpd.conf

echo "Starting FTP Server"
# https://www.systutorials.com/docs/linux/man/8-vsftpd/
exec vsftpd /etc/vsftpd/vsftpd.conf