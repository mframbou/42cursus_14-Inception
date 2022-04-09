# To start server in the right directoy
cd /home/server/

if [ ! -f /home/server/eula.txt ]; then

    echo "Starting server to generate EULA file"
    java -Xmx1024M -jar /home/server/server.jar --nogui

    echo "Accepting EULA"
    sed -i 's/eula=false/eula=true/g' /home/server/eula.txt
fi

exec java -Xmx1024M -jar /home/server/server.jar --nogui