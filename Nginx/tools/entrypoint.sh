#!/bin/sh

# https://stackoverflow.com/questions/21297853/how-to-determine-ssl-cert-expiration-date-from-a-pem-encoded-certificate
# Check if certificate present AND valid withing the next hour, if not generate a self-signed temporary one
# If command did NOT succeed (returned != 0), then execute
if [ ! -f /home/nginx-selfsigned.crt ] || [ ! -f /home/nginx-selfsigned.key ] || ! openssl x509 -checkend 360 -noout -in /home/nginx-selfsigned.crt; then
	echo "SSL Certificate will expire within 1 hour, generating temporary self-signed certificate"
	# https://www.digitalocean.com/community/tutorials/how-to-create-a-self-signed-ssl-certificate-for-nginx-in-ubuntu-16-04
	# -subj to use arguments instead of interactive prompt, see https://www.shellhacks.com/create-csr-openssl-without-prompt-non-interactive/
	# X509 = norm for public key certificates 
	openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /home/nginx-selfsigned.key -out /home/nginx-selfsigned.crt -subj "/C=FR/ST=Le Royaume Des Cracks/L=Nice/O=Crackito Corp./OU=Departement des bg/CN=crackito.fr" -addext "subjectAltName = DNS:127.0.0.1"

	echo "Successfully generated temporary self-signed certificate"
fi

# https://stackoverflow.com/questions/18861300/how-to-run-nginx-within-a-docker-container-without-halting
# -g = global directives, daemon on|off determines if nginx should run as a daemon (background process) or not
exec nginx -g 'daemon off;'