FROM alpine:3.14

# Download and install mariadb
# https://superuser.com/questions/1055060/how-to-install-a-specific-package-version-in-alpine

RUN apk update

# Latest versions as of 03/28/2022
# https://pkgs.alpinelinux.org/
RUN apk add mariadb mariadb-client

# To use envsusbt
RUN apk add gettext

# Initialize data directory and create system tables
# https://mariadb.com/kb/en/mysql_install_db/
# /var/lib hold dynamic data libraries/files
# It might be necessary to specify other options such as --basedir or --datadir if mysql_install_db does not use the correct locations for the installation directory or data directory

# Create folder otherwise mysql does not find the socket located at /run/mysqld.sock
# https://stackoverflow.com/questions/42153059/mysqld-safe-directory-var-run-mysqld-for-unix-socket-file-dont-exists
RUN mkdir /run/mysqld

# No such file or directory when volume not existing
RUN mkdir -p /var/lib/mysql

COPY ./mariadb-config.cnf /etc/my.cnf.d/mariadb-server.cnf

COPY ./run_mariadb.sh /run_mariadb.sh
COPY ./wordpress.sql /wordpress.sql

# Run the script separately because mounting of volume is done at runtime, so install on mounted volume not on "base" volume
CMD ["sh", "/run_mariadb.sh"]