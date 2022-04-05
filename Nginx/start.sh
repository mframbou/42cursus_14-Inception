#!/bin/sh

if [ ! -f /etc/ssl/certs/nginx-selfsigned.crt ]; then
	echo "Generating self-signed certificate"
	# https://www.digitalocean.com/community/tutorials/how-to-create-a-self-signed-ssl-certificate-for-nginx-in-ubuntu-16-04
	# -subj to use arguments instead of interactive prompt, see https://www.shellhacks.com/create-csr-openssl-without-prompt-non-interactive/
	# X509 = norm for public key certificates 
	openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt -subj "/C=FR/ST=Le Royaume Des Cracks/L=Nice/O=Crackito Corp./OU=Departement des bg/CN=gigachad.fr" -addext "subjectAltName = DNS:127.0.0.1"

	echo "Successfully generated certificate"
fi

exec nginx -g 'daemon off;'