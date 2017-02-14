#! /bin/bash


#Example  use:
#./remotebackup.sh username remoteip /directory/to/backup nameofbackupfile

# Arguments 
# $1 username of remote user
# $2 ip address of remote server
# $3 remote directory to be backed up (e.g. /var/www/bob)
# $4 is the name of the .tar.gz backup (e.g. bobbackup) 
# End of arguments 

# Global variables
DATE=`date`
# Global variables end

# Script begin

echo "Remote Backup Beginning at $DATE"
echo "Connecting to remote server."
ssh  $1@$2 "cd $3 && tar cvfz $HOME/$4.tar.gz ."
scp $1@$2:/home/$1/$4.tar.gz .
echo "Backup Completed."

# Script complete 
