FROM alpine:3.14

# See alpine linux wiki for all sources (https://wiki.alpinelinux.org/wiki/WordPress)
# mkdir -p creates parents if needed
RUN apk update && apk add php7-common php7-session php7-iconv php7-json php7-gd php7-curl php7-xml php7-mysqli php7-imap php7-cgi fcgi php7-pdo php7-pdo_mysql php7-soap php7-xmlrpc php7-posix php7-mcrypt php7-gettext php7-ldap php7-ctype php7-dom php7-simplexml \
	php7 php7-fpm mariadb-client wget; \
	\
	mkdir -p /var/www/html

COPY ./conf/www.conf /etc/php7/php-fpm.d/www.conf
COPY ./tools/ /home/

CMD [ "sh", "/home/entrypoint.sh" ]