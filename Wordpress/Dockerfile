# https://wiki.alpinelinux.org/wiki/WordPress
FROM alpine:3.15.2

RUN apk update

RUN apk add php7-common php7-session php7-iconv php7-json php7-gd php7-curl php7-xml php7-mysqli php7-imap php7-cgi fcgi php7-pdo php7-pdo_mysql php7-soap php7-xmlrpc php7-posix php7-mcrypt php7-gettext php7-ldap php7-ctype php7-dom php7-simplexml

RUN apk add wget mariadb-client

# -p creates parents if needed
# /usr/share contains architecture independant shareable text files
RUN mkdir -p /usr/share/webapps/

RUN cd /usr/share/webapps

RUN wget https://wordpress.org/wordpress-5.9.2.tar.gz

# x = extract, z = use gzip, v = verbose, f = file
RUN tar -xzv -f wordpress-5.9.2.tar.gz

RUN rm wordpress-5.9.2.tar.gz

# Create a symlink to wordpress folder
#RUN ln -s /usr/share/webapps/wordpress/ /var/www/localhost/htdocs/wordpress

COPY ./test.sh /pouet.sh


CMD [ "sh", "/pouet.sh" ]