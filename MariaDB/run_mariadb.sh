#!/bin/sh

# Install db only one (if non-existent)
# You should either run mysql_install_db with the same account that will be running mariadbd or run it as root with --user
if [ ! -d /var/lib/mysql/mysql ]; then
	ls -l /var/lib/mysql/mysql
	echo "Installing database"
	
	mariadb-install-db --user=root --datadir=/var/lib/mysql

	# & at the end start process in the background
	mariadbd --user=root &

	# Pings check whether server is running, 0 if it is, 1 if not, retry 30 times
	# To check for exit status, don't use brackets, only command directly
	mariadb-admin --wait=30 ping

	MYSQL_RUNNING=$?
	if [ $MYSQL_RUNNING -eq 1 ]; then
		echo "MariaDB not running after 30 retry, exiting"
		exit 1
	fi

	echo "Creating wordpress user / db"
	mariadb < /wordpress.sql

	echo "Successfully intitialized mariadb"

	# Kill to reopen after, because if the process is in the background the container stops
	pkill mariadbd
fi

mariadbd --user=root
