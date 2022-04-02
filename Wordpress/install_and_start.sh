#!/bin/sh

cd /var/www/html

# Just check if wordpress is already installed
if [ ! -f "/var/www/html/index.php" ]; then
	# x = extract, z = use gzip, v = verbose, f = file
	echo "Downloading wordpress..."

	# Send both stdout to null to hide, keep error logged
	wget https://wordpress.org/wordpress-5.9.2.tar.gz &> /dev/null

	# Send both stdout to null to hide, keep error logged
	tar -xzv -f wordpress-5.9.2.tar.gz > /dev/null

	echo "Successfully downloaded wordpress"

	rm wordpress-5.9.2.tar.gz

	mv ./wordpress/* ./

	rmdir ./wordpress
else
	echo "Wordpress already present, skipping installation"
fi

php-fpm7 -F