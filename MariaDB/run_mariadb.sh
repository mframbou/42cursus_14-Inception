#!/bin/sh

# Install db only one (if non-existent)
# You should either run mysql_install_db with the same account that will be running mariadbd or run it as root with --user
if [ ! -d /var/lib/mysql/mysql ]; then
	ls -l /var/lib/mysql/mysql
	echo "Installing database"
	
	mariadb-install-db --user=root --datadir=/var/lib/mysql

	# & at the end start process in the background
	mariadbd --user=root --unix_socket=OFF &

	# Pings check whether server is running, 0 if it is, 1 if not, retry 30 times
	# To check for exit status, don't use brackets, only command directly
	mariadb-admin --wait=30 ping

	MYSQL_RUNNING=$?
	if [ $MYSQL_RUNNING -eq 1 ]; then
		echo "MariaDB not running after 30 retry, exiting"
		exit 1
	fi

	echo "Creating wordpress user / db"

	# Note for myself: don't forget quotes around the passwords / hostnames / usernames, otherwise it won't work (since everything is in double quotes env variables are still interpreted)

	# Use *.* and not * for all databases (To use * we need to select a DB, when using *.* it basically means ALL)
	# https://dev.mysql.com/doc/refman/8.0/en/grant.html

	# Also hanges root password from blank to something
	
	# Envsubst subsitutes environment in text, a lot cleaner
	# https://mariadb.com/kb/en/authentication-plugin-unix-socket/
	mariadb -e "$(envsubst < /wordpress.sql)"

	echo "Successfully intitialized mariadb"

	# Since mariadbd is launched as a background process, wait for it to exit (basically shouldn't)
	# Otherwise the script would terminate here since there is no foreground process anymore
	wait
else
    #--user=root to run daemon as root, mandatory
	# https://mariadb.com/kb/en/authentication-plugin-unix-socket/
	# unix_socket is a builtin plugin that allows to not use a password when connection from local machine, disable it here
	# https://mariadb.com/kb/en/authentication-plugin-unix-socket/#options
	mariadbd --user=root --unix_socket=OFF
fi

