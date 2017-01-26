#! /bin/bash

DATE=`date`
URL=www.website.com # Insert the server ip address or domain name here
EMAIL=root@localhost.com #Insert the admin's email address here. 

ping -c 3 $URL > /dev/null

if [ $? -eq 0 ]
	then 
		echo "Ping Test Completed Successfully on $DATE" >> $HOME/pingtest.log

elif [ $? -eq 1 ] 
	then
		echo "Ping Test Failed on $DATE!" >> $HOME/pingtest.log && echo "Ping Test Failed on $DATE!" | mail -s "Ping Test Failure!" $EMAIL

fi 



 
