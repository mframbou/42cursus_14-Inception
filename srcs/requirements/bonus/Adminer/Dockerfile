# https://wiki.alpinelinux.org/wiki/WordPress
FROM alpine:3.14

#https://linuxconfig.org/using-adminer-to-manage-your-databases
# Download adminer and set it's name as index.php (single file so it's easier with nginx after)
RUN apk update && apk add php7-common php7-session php7-iconv php7-json php7-gd php7-curl php7-xml php7-mysqli php7-imap php7-cgi fcgi php7-pdo php7-pdo_mysql php7-soap php7-xmlrpc php7-posix php7-mcrypt php7-gettext php7-ldap php7-ctype php7-dom php7-simplexml \
	php7 php7-fpm wget mariadb-client; \
	\
	mkdir -p /var/www/html; \
	\
	wget https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1.php --output-document=/var/www/html/index.php

COPY ./conf/www.conf /etc/php7/php-fpm.d/www.conf

# -F == --nodaemonize, force to run in foreground
CMD [ "php-fpm7", "-F" ]