#!/bin/sh

wait_and_init_mariadb()
{
	# Pings check whether server is running, 0 if it is, 1 if not, retry 30 times
	# To check for exit status, don't use brackets, only command directly
	mariadb-admin --wait=30 ping

	MYSQL_RUNNING=$?

	# If mariadb is not running the container should've had exited by now (since mariadb is foreground process)
	if [ $MYSQL_RUNNING -eq 1 ]; then
		echo "MariaDB not running after 30 retries, exiting"
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

	chown -R root /var/lib/mysql
	
	echo "Successfully intitialized mariadb"
}

# Install db only one (if non-existent)
# You should either run mysql_install_db with the same account that will be running mariadbd or run it as root with --user
if [ ! -d /var/lib/mysql/mysql ]; then
	ls -l /var/lib/mysql/mysql
	echo "Installing database"
	
	mariadb-install-db --user=root --datadir=/var/lib/mysql

	# & at the end start process in the background
	# https://linuxcommand.org/lc3_man_pages/seth.html
	# https://unix.stackexchange.com/questions/637002/how-do-i-foreground-a-job-in-a-script, https://stackoverflow.com/questions/5163144/what-are-the-special-dollar-sign-shell-variables
	# &! is PID of most recent background command

	# First launch the script which will wait in the background, then launch the daemon as PID 1 (foreground)
	wait_and_init_mariadb &
fi

#--user=root to run daemon as root, mandatory
# https://mariadb.com/kb/en/authentication-plugin-unix-socket/
# unix_socket is a builtin plugin that allows to not use a password when connection from local machine, disable it here
# https://mariadb.com/kb/en/authentication-plugin-unix-socket/#options

# exec to make it PID 1
exec mariadbd --user=root