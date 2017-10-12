#! /bin/bash
#This script automatically updates software packages on Debian-based systems, creates a logfile detailing those upgrades, and emails information about those upgrades.  
#This script requires that the package mailutils be installed. Execute "apt-get install mail-utils" before using it. 
#The most useful way to use this script is to schedule it with cron.  An sample cron entry is included in "usage"

#Arguments:
# $1 is the name of the server upon which the updates are being run
# $2 is the email address you'd like to have updates mailed to

# Usage:
# ./automaticupdater.sh nameofserver name@emailaddress.com
# 0 7 * * * /root/automaticupdater.sh exampleservername johndoe@examlewebsite.com (this sample cron entry that runs at 7 AM everyday)

if [ $USER != "root" ] ; then #This tests for superuser privileges and exits the script if the script does not have them
	echo "This script requires root privileges"
	exit
fi

DATE=`date`

apt-get update >> /dev/null
UPDATES=`apt-get -y upgrade` #This variable captures the standard output of "apt-get upgrade" command so it can be printed in logs and emails


if [ $? -eq 0 ] ; then
	echo "Updates successfully run on $DATE" >> /root/updates.log
	echo $UPDATES >> /root/updates.log
	echo "Updates successfully run on $DATE.  The following changes were made: $UPDATES" | mail -s "Software updates for $1 completed successfully on $DATE" $2 
	else echo "Updates failed on $DATE" >> /root/updates.log
	echo $UPDATES >> /root/updates.log
	echo "Updates failed on $DATE." | mail -s "Software updates for $1 completed successfuully on $DATE." $2 
fi
