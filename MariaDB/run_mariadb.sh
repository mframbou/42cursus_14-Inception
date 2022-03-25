#!/bin/sh

# You should either run mysql_install_db with the same account that will be running mysqld or run it as root with --user
mysql_install_db --user=root --datadir=/var/lib/mysql

mysqld --user=root