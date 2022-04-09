FROM alpine:3.14

# Download and install mariadb
# https://superuser.com/questions/1055060/how-to-install-a-specific-package-version-in-alpine
# Each statement adds a layer to an image (and so size since history is kept like git, so run the most in a single statement)

# Mariadb, mariadb-client = mariadb, gettext = envsubst command

# Initialize data directory and create system tables
# https://mariadb.com/kb/en/mysql_install_db/
# /var/lib hold dynamic data libraries/files
# It might be necessary to specify other options such as --basedir or --datadir if mysql_install_db does not use the correct locations for the installation directory or data directory
# Create folder otherwise mysql does not find the socket located at /run/mysqld.sock
# https://stackoverflow.com/questions/42153059/mysqld-safe-directory-var-run-mysqld-for-unix-socket-file-dont-exists
RUN apk update && apk add mariadb mariadb-client gettext; \
	\
	mkdir -p /run/mysqld

COPY ./conf/mariadb-config.cnf /etc/my.cnf.d/mariadb-server.cnf
COPY ./tools/ /home/

# Run the script separately because mounting of volume is done at runtime, so install on mounted volume not on "base" volume
# Argument is the path to the sql init file
CMD ["sh", "/home/entrypoint.sh", "/home/wordpress.sql"]