#!/bin/sh

echo "Creating user $FTP_USER"
addgroup -g 433 -S $FTP_USER
adduser -u 431 -D -G $FTP_USER -h /home/$FTP_USER -s /bin/false  $FTP_USER
echo "$FTP_USER:$FTP_PASSWORD" | /usr/sbin/chpasswd
chown $FTP_USER:$FTP_USER /home/$FTP_USER/ -R

echo "" >> /etc/vsftpd/vsftpd.conf
echo "pasv_min_port=$FTP_PASV_MIN_PORT" >> /etc/vsftpd/vsftpd.conf
echo "pasv_max_port=$FTP_PASV_MAX_PORT" >> /etc/vsftpd/vsftpd.conf

# https://www.systutorials.com/docs/linux/man/8-vsftpd/
# https://docs.docker.com/compose/faq/#:~:text=Compose%20stop%20attempts%20to%20stop,they%20receive%20the%20SIGTERM%20signal.
# Docker send SIGTERM then SIGKILL
stop_vsftpd()
{
    echo "Received stop signal, sending SIGTERM to vsftpd"
    kill -SIGTERM $(pidof vsftpd)
}

# vsftpd doesn't seems to handle sigint, so when receiving it, send sigterm
# (faster shutdown when using docker compose)
#trap stop_vsftpd SIGINT SIGTERM
trap stop_vsftpd SIGINT SIGTERM

echo "Starting FTP Server"
vsftpd /etc/vsftpd/vsftpd.conf &
wait $(pidof vsftpd)