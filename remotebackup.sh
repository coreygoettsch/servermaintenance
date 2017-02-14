#! /bin/bash

#This script connects  to a remote server via ssh, creates a .tar.gz backup, and uses scp to secure copy it to the host computer. 
# $1 is username, $2 is the server address, $3 is the remote directory to be backed up, and $4 is the name of the backupfile

DATE=`date`

echo "Remote Backup Beginning at $DATE"
echo "Connecting to remote server."
ssh  $1@$2 "cd $3 && tar cvfz $HOME/$4.tar.gz ."
scp $1@$2:/home/$1/$4.tar.gz .
echo "Backup Completed."
