FROM alpine:3.14

# Nginx + openssl for ssl (https)
RUN apk update && apk add nginx openssl

# https://codingwithmanny.medium.com/custom-wordpress-docker-setup-8851e98e6b8
COPY ./conf/nginx.conf /etc/nginx/http.d/default.conf
COPY ./tools/ /home/

CMD [ "sh", "/home/entrypoint.sh" ]