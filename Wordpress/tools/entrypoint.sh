#!/bin/sh

# Just check if wordpress is already installed
if [ ! -f "/var/www/html/wordpress/index.php" ]; then
	echo "Downloading wordpress..."

	# By convention, a dash in a filename position represents stdin/stdout (the most appropriate)
	# Download file, output to stdout then pipe to tar to extract directly
	# -O = output file (here - = stdout), -q = quiet mode
	# -x = extract, -v = verbose, -z use GZIP to manage automatically, -C = change directory (same as --directory)
	wget -q -O - https://wordpress.org/wordpress-5.9.2.tar.gz | tar -xvz -C /var/www/html
	
	chmod -R 777 /var/www/html
	echo "Successfully downloaded wordpress"
	echo "Installing wordpress..."

	echo "Establishing connection to mariadb..."
	# Wait for user to be created and working, see https://stackoverflow.com/questions/18522847/mysqladmin-ping-error-code
	# ping returns 0 even if connection is refused for user (because server is running), status doesn't
	ATTEMPT=1
	while ! mysqladmin status --host=$WORDPRESS_DB_HOST --user=$WORDPRESS_DB_USER --password=$WORDPRESS_DB_PASSWORD --silent; do
		echo "Waiting for database connection (attempt number $ATTEMPT)"
		ATTEMPT=$((ATTEMPT + 1))
		if [ $ATTEMPT -gt 30 ]; then
			echo "Connection couldn't be established after 30 tries, exiting..."
			exit 1
		fi
		sleep 1
	done
	echo "Successfully established mariadb connection"

	echo "Creating wordpress config"
	wp-cli config create --path=/var/www/html/wordpress/ --dbname=$WORDPRESS_DB_NAME --dbuser=$WORDPRESS_DB_USER --dbpass=$WORDPRESS_DB_PASSWORD --dbhost=$WORDPRESS_DB_HOST --allow-root
	echo "Installing wordpress base website"
	wp-cli core install --path=/var/www/html/wordpress/ --title="Crackito's kingdom" --admin_user=$WORDPRESS_ADMIN_USER --admin_password=$WORDPRESS_ADMIN_PASSWORD --admin_email=$WORDPRESS_ADMIN_EMAIL --skip-email --url=localhost --allow-root
else
	echo "Wordpress already present, skipping installation"
fi

# -F == --nodaemonize, force to run in foreground
# exec to make it PID 1
exec php-fpm7 -F