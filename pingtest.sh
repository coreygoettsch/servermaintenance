#! /bin/bash

<<<<<<< HEAD
# Argument 1 ($1) is the server's url, and Argument 2 ($2)is the email address to which an error message should be sent
# the syntax of the this shell script ought to be "./pingtest.sh URL Email@address.com

DATE=`date`

ping -c 3 $1 > /dev/null
=======
DATE=`date`
URL=www.website.com # Insert the server ip address or domain name here
EMAIL=root@localhost.com #Insert the admin's email address here. 

ping -c 3 $URL > /dev/null
>>>>>>> master

if [ $? -eq 0 ]
	then 
		echo "Ping Test Completed Successfully on $DATE" >> $HOME/pingtest.log

elif [ $? -eq 1 ] 
	then
<<<<<<< HEAD
		echo "Ping Test Failed on $DATE!" >> $HOME/pingtest.log && echo "Ping Test Failed on $DATE!" | mail -s "Ping Test Failure!" $2
=======
		echo "Ping Test Failed on $DATE!" >> $HOME/pingtest.log && echo "Ping Test Failed on $DATE!" | mail -s "Ping Test Failure!" $EMAIL
>>>>>>> master

fi 



 
