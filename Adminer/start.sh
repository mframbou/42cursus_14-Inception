#!/bin/sh

# Just check if adminer is already installed
if [ ! -f "/var/www/html/index.php" ]; then
	# x = extract, z = use gzip, v = verbose, f = file
	echo "Installing adminer..."

	# Send both stdout to null to hide, keep error logged
	tar -x -f /adminer-files/adminer-5.9.2.tar.gz --directory=/var/www/html > /dev/null

	echo "Successfully installed adminer"

	# Delete archive
	rm /adminer-files/adminer-5.9.2.tar.gz

	# Move everything from adminer folder to root of nginx folder
	mv /var/www/html/adminer/* /var/www/html/

	# Delete extracted archive folder
	rmdir /adminer-files/
	
else
	echo "adminer already present, skipping installation"
fi

# Force to stay in foreground with -F
php-fpm7 -F