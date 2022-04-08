FROM alpine:3.14

# See alpine linux wiki for all sources (https://wiki.alpinelinux.org/wiki/WordPress)
# mkdir -p creates parents if needed
# https://www.php.net/manual/fr/intro.phar.php
# Phar is like a .jar, often used for libaries / packages
RUN apk update && apk add php7-common php7-session php7-iconv php7-json php7-gd php7-curl php7-xml php7-mysqli php7-imap php7-cgi fcgi php7-pdo php7-pdo_mysql php7-soap php7-xmlrpc php7-posix php7-mcrypt php7-gettext php7-ldap php7-ctype php7-dom php7-simplexml \
	php7 php7-fpm php-phar mariadb-client wget; \
	\
	mkdir -p /var/www/html

# Add execute permission for everyone directly
ADD https://github.com/wp-cli/wp-cli/releases/download/v2.6.0/wp-cli-2.6.0.phar /usr/local/bin/wp-cli
RUN chmod 755 /usr/local/bin/wp-cli
COPY ./conf/www.conf /etc/php7/php-fpm.d/www.conf
COPY ./tools/ /home/

CMD [ "sh", "/home/entrypoint.sh" ]