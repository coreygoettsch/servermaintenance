#! /bin/bash

# Argument 1 ($1) is the server's url, and Argument 2 ($2)is the email address to which an error message should be sent

DATE=`date`

ping -c 3 $1 > /dev/null


if [ $? -eq 0 ]
	then 
		echo "Ping Test Completed Successfully on $DATE" >> $HOME/pingtest.log

elif [ $? -eq 1 ] 
	then
		echo "Ping Test Failed on $DATE!" >> $HOME/pingtest.log 
	       	echo "Ping Test Failed on $DATE!" | mail -s "Ping Test Failure!" $2

fi 



 
