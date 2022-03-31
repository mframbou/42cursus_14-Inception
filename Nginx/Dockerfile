FROM alpine:3.15.2

RUN apk update

# https://pkgs.alpinelinux.org/
RUN apk add nginx=1.20.2-r0

# https://codingwithmanny.medium.com/custom-wordpress-docker-setup-8851e98e6b8
COPY ./nginx-config.conf /etc/nginx/http.d/default.conf

# https://stackoverflow.com/questions/18861300/how-to-run-nginx-within-a-docker-container-without-halting
# -g = global directives, daemon on|off determines if nginx should run as a daemon (background process) or not
CMD [ "nginx", "-g", "daemon off;" ]