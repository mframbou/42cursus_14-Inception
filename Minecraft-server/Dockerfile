FROM alpine:3.14

# https://minecraft.fandom.com/wiki/Tutorials/Setting_up_a_server
# https://mcversions.net/ - official minecraft download links
# jre: https://pkgs.alpinelinux.org/package/edge/community/x86/openjdk8-jre
RUN apk update && apk add openjdk8-jre

RUN mkdir -p /home/server/

ADD https://launcher.mojang.com/v1/objects/b58b2ceb36e01bcd8dbf49c8fb66c55a9f0676cd/server.jar /home/server/server.jar

COPY ./tools/ /home/
# Change MOTD and allow crack
COPY ./conf/server.properties /home/server/server.properties

CMD [ "sh", "/home/entrypoint.sh" ]