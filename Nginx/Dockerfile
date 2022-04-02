FROM alpine:3.14

RUN apk update

# https://pkgs.alpinelinux.org/
RUN apk add nginx=1.20.2-r0

# For ssl certificate
RUN apk add openssl

# https://codingwithmanny.medium.com/custom-wordpress-docker-setup-8851e98e6b8
COPY ./nginx-config.conf /etc/nginx/http.d/default.conf

COPY ./start.sh /start.sh

# https://stackoverflow.com/questions/18861300/how-to-run-nginx-within-a-docker-container-without-halting
# -g = global directives, daemon on|off determines if nginx should run as a daemon (background process) or not
CMD [ "sh", "/start.sh" ]