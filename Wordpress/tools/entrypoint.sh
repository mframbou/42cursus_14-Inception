#!/bin/sh

# Just check if wordpress is already installed
if [ ! -f "/var/www/html/wordpress/index.php" ]; then
	echo "Downloading wordpress..."

	# By convention, a dash in a filename position represents stdin/stdout (the most appropriate)
	# Download file, output to stdout then pipe to tar to extract directly
	# -O = output file (here - = stdout), -q = quiet mode
	# -x = extract, -v = verbose, -z use GZIP to manage automatically, -C = change directory (same as --directory)
	wget -q -O - https://wordpress.org/wordpress-5.9.2.tar.gz | tar -xvz -C /var/www/html

	echo "Successfully downloaded and installed wordpress"	
else
	echo "Wordpress already present, skipping installation"
fi

# -F == --nodaemonize, force to run in foreground
# exec to make it PID 1
exec php-fpm7 -F