#!/bin/sh

if [ ! -f ./server.jar ]; then
    cp /home/server.jar ./server.jar

    echo "Starting server to generate EULA file"
    java -Xmx1024M -jar ./server.jar --nogui

    echo "Accepting EULA"
    sed -i 's/eula=false/eula=true/g' ./eula.txt
else
    echo "Minecraft server already present, skipping installation"
fi

rm /home/server.jar
mv /home/server.properties ./server.properties

exec java -Xmx1024M -jar ./server.jar --nogui