FROM alpine:3.14

# https://wiki.alpinelinux.org/wiki/FTP
# https://www.hiroom2.com/2017/08/22/alpinelinux-3-6-vsftpd-en/
# Very Secure FTP Daemon (vsftpd)
RUN apk update && apk add vsftpd

COPY ./conf/vsftpd.conf /etc/vsftpd/vsftpd.conf
COPY ./tools /home/

CMD [ "sh", "/home/entrypoint.sh" ]