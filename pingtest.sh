#! /bin/bash

# Example use: ./pingtest.sh url email@address.com

# Arguments
# $1 is the url of the website to be tested
# $2 is the email address that will receive a warning if the test fails


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



 
