#! /bin/bash

echo "Welcome to the Server Login Script!"
echo ""
echo "Which server would you like to access?: server1, server2, server3, or server4?"
read SERVERNAME

if [ $SERVERNAME == "server1" ]
        then
                ssh ip.address.1.0

elif [ $SERVERNAME == "server2" ]
        then
                ssh ip.address.2.0

elif [ $SERVERNAME == "server3" ]
        then
                ssh ip.address.3.0

elif [ $SERVERNAME == "server4" ]
        then
                ssh ip.address.4.0
else echo "This server does not exist"


fi

