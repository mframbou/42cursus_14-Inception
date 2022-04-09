FROM alpine:3.14

RUN apk update && apk add redis

# Change bind-address to listen to every address
# dir /var/lib/redis (default directory)
# Disable protected mode
COPY ./conf/redis.conf /etc/redis.conf

# To choose config, provide is as argument
CMD [ "redis-server", "/etc/redis.conf" ]