#!/bin/sh

# Just check if wordpress is already installed
if [ ! -f "/var/www/html/index.php" ]; then
	# x = extract, z = use gzip, v = verbose, f = file
	echo "Installing wordpress..."

	# Send both stdout to null to hide, keep error logged
	tar -x -f /wordpress-files/wordpress-5.9.2.tar.gz --directory=/var/www/html > /dev/null

	echo "Successfully installed wordpress"

	# Delete archive
	rm /wordpress-files/wordpress-5.9.2.tar.gz

	# Move everything from wordpress folder to root of nginx folder
	mv /var/www/html/wordpress/* /var/www/html/

	# Delete extracted archive folder
	rmdir /wordpress-files/
	
else
	echo "Wordpress already present, skipping installation"
fi

# Force to stay in foreground with -F
php-fpm7 -F