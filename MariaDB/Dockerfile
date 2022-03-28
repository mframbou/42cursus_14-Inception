FROM alpine:3.15.2

# Download and install mariadb
RUN apk add mariadb mariadb-client

# Initialize data directory and create system tables
# https://mariadb.com/kb/en/mysql_install_db/
# /var/lib hold dynamic data libraries/files
# It might be necessary to specify other options such as --basedir or --datadir if mysql_install_db does not use the correct locations for the installation directory or data directory

# Create folder otherwise mysql does not find the socket located at /run/mysqld.sock
# https://stackoverflow.com/questions/42153059/mysqld-safe-directory-var-run-mysqld-for-unix-socket-file-dont-exists
RUN mkdir /run/mysqld

COPY ./run_mariadb.sh /run_mariadb.sh
COPY ./wordpress.sql /wordpress.sql

# Run the script separately because mounting of volume is done at runtime, so install on mounted volume not on "base" volume
CMD ["sh", "/run_mariadb.sh"]