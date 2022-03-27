#!/bin/sh

# Install db only one (if non-existent)
# You should either run mysql_install_db with the same account that will be running mysqld or run it as root with --user
if [ ! -d /var/lib/mysql/mysql ]; then
	ls -l /var/lib/mysql/mysql
	echo "Installing database"
	mysql_install_db --user=root --datadir=/var/lib/mysql
fi

mysqld --user=root