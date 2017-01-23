#! /bin/bash
# This is an interactive script that makes it easy to access a number of servers without having to remember usernames and ip addresses.
echo "Welcome to the Server Login Script!"
echo ""
echo "Which server would you like to access: server1, server2, server3, or server4?" #Change server* to reflect an easily remembered server name like "mywebsite"
echo "type name now:" && read SERVERNAME
# The script reads the input, and if it matches one of the server names, it connects to it.
# The script was written with four servers, but it can easily be modified by adding additional entries below.

if [ $SERVERNAME == "server1" ]
        then
                echo "Connecting now..."
                ssh user@ip.address.1.0 #In each line, add the proper username and ip address to connect.  

elif [ $SERVERNAME == "server2" ]
        then
                echo "Connecting now..."
                ssh user@ip.address.2.0

elif [ $SERVERNAME == "server3" ]
        then
                echo "Connecting now...:
                ssh user@ip.address.3.0

elif [ $SERVERNAME == "server4" ]
        then
                echo "Connecting now..."
                ssh user@ip.address.4.0
else echo "This server does not exist"


fi

