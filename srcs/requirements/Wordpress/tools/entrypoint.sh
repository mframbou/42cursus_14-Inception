#!/bin/sh

# Just check if wordpress is already installed
if [ ! -f "/var/www/html/wordpress/index.php" ]; then
	echo "Downloading wordpress..."

	# By convention, a dash in a filename position represents stdin/stdout (the most appropriate)
	# Download file, output to stdout then pipe to tar to extract directly
	# -O = output file (here - = stdout), -q = quiet mode
	# -x = extract, -v = verbose, -z use GZIP to manage automatically, -C = change directory (same as --directory)
	# https://stackoverflow.com/questions/19372373/how-to-add-progress-bar-to-a-somearchive-tar-xz-extract
	wget -O /home/wordpress.tar.gz https://wordpress.org/wordpress-5.9.2.tar.gz

	echo "Extracting wordpress..."
	pv /home/wordpress.tar.gz | tar -xz -C /var/www/html
	rm /home/wordpress.tar.gz
	
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
		sleep 2
	done
	echo "Successfully established mariadb connection"

	echo "Creating wordpress config"
	wp-cli config create --path=/var/www/html/wordpress/ --dbname=$WORDPRESS_DB_NAME --dbuser=$WORDPRESS_DB_USER --dbpass=$WORDPRESS_DB_PASSWORD --dbhost=$WORDPRESS_DB_HOST --allow-root
	
	echo "Installing wordpress base website"
	wp-cli core install --path=/var/www/html/wordpress/ --title="Crackito's kingdom" --admin_user=$WORDPRESS_ADMIN_USER --admin_password=$WORDPRESS_ADMIN_PASSWORD --admin_email=$WORDPRESS_ADMIN_EMAIL --skip-email --url=localhost --allow-root

	echo "Creating user $WORDPRESS_USER"
	wp-cli user create $WORDPRESS_USER $WORDPRESS_USER_EMAIL --user_pass=$WORDPRSES_USER_PASSWORD --role=subscriber --path=/var/www/html/wordpress/ --allow-root
	
	# https://github.com/rhubarbgroup/redis-cache/wiki/WP-CLI-Commands
	echo "Installing redis cache plugin"
	wp-cli plugin install --path=/var/www/html/wordpress/ redis-cache --activate --allow-root

	# https://wordpress.org/support/topic/plugin-ignores-define-wp_redis_host-xx-xx-xx-xx-when-external/
	# Workaround is to just put it at the top of the file by doing so
	# https://stackoverflow.com/questions/6739258/how-do-i-add-a-line-of-text-to-the-middle-of-a-file-using-bash
	# Insert after authentication config
	sed -ie "/WP_CACHE_KEY_SALT/a/** Redis configuration */\ndefine('WP_REDIS_HOST', '$WP_REDIS_HOST');" /var/www/html/wordpress/wp-config.php
	wp-cli --path=/var/www/html/wordpress/ redis enable --allow-root
	echo "Successfully installed and enabled redis cache plugin"

	echo "Making dummy post"
	wp-cli post create --path=/var/www/html/wordpress/ --post_title='What does ginger mean ?' --post_content='Go ask oronda' --post_status=publish --allow-root

	echo "Successfully initialized wordpress, starting php-fpm"
else
	echo "Wordpress already present, starting php-fpm"
fi

# -F == --nodaemonize, force to run in foreground
# exec to make it PID 1
exec php-fpm7 -F