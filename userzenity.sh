#! /bin/bash
#This script provides a graphical interface for user maintenance tasks
# NOTE: This script requires zenity to work.

# Functions

list_users() {
	zenity --info\
		--text="The format is: username userid"\
		--height=100\
		--width=150
	LIST=`awk -F':' '$3>=1000 {print $1 " " $3}' /etc/passwd`
	zenity --info\
		--title="Users on this system."\
		--text="$LIST"\
		--height=200\
		--width=200
}
function list_groups() {
	USER=`zenity --entry \
		--title="Listing Groups of a User"\
		--text="Enter Username"\
		--entry-text="Username"`
	GROUP=`groups $USER`
	zenity --info\
		--title="Groups of $USER"\
		--text="$GROUP"\
		--height=200\
		--width=200
}

function add_user() {
USER=`zenity --entry\
	--title="Creating a new user"\
	--text="Enter username"\
	--entry-text="Username"`
PASS=`zenity --entry\
	--title="Creating a new user"\
	--text="Enter user's password"\
	--hide-text`
PASSWORD=$(perl -e 'print crypt($ARGV[0], "password")' $PASS)
useradd -m -s  /bin/bash -p $PASSWORD $USER
if [ $? -eq 0 ] ; then
	zenity --info\
		--text="$USER created successfully"\
		--title="Success"
else zenity --error\
	--text="User not created."
fi
} 
function add_group() { 
USER=`zenity --entry\
	--title="Adding user to a group."\
	--text="Enter the username"\
	--entry-text="Username"`
GROUP=`zenity --entry\
	--title="Adding user to a new group."\
	--text="Enter the group name"\
	--entry-text="Groupname"`
usermod -aG $GROUP $USER
if [ $? -eq 0 ] ; then
	zenity --info\
		--text="$USER added successfully to $GROUP"
else zenity --error\
	--text="User not added to group."
fi
}
function modify_access() {
USER=`zenity --entry\
	--width=250\
	--title="Changing Access to Shell"\
	--text="Enter the username"\
	--entry-text="Username"`
GRANT=`zenity --list\
	--title="Grant or restrict access to user."\
	--width=350\
	--height=200\
	--column="Choice number" --column="Task to perform."\
	1 "Restrict Access to Shell"\
	2 "Grant Access to Shell"`
if [ $GRANT == "1" ] ; then
	usermod -s /usr/sbin/nologin $USER
	zenity --info\
		--text="$USER can no longer log in."
elif [ $GRANT == "2" ] ; then
	usermod -s /bin/bash $USER
	zenity --info\
		--text="$USER can now log in."
else zenity --info\
	--text="Something weird has happened here."
fi
if [ $? -eq 0 ] ; then
	zenity --info\
		--text="Shell access successfully changed"
else zenity --error\
	--text="Shell access not changed"
fi
}
function delete_user() { 
zenity --question\
	--text="Are you sure want to delete a user?"
if [ $? == 1 ] ; then
	zenity --info\
		--text="Aborting task."
	exit 1
else zenity --info\
	--text="Proceeding to user deletion."
fi
USER=`zenity --entry\
	--title="User to be Deleted"\
	--width=200\
	--text="Enter username to be deleted"\
	--entry-text="Username"`
userdel $USER && rm -rf /home/$USER
if [ $? == 0 ] ; then
zenity --info\
	--text="$USER successfully deleted."
else zenity --warning\
	--text="user deletion failed."
fi
}  
function add_sudo() {
USER=`zenity --entry\
	--title="Name of user to receive sudo privileges"\
	--text="Enter user name receiving sudo rights"\
	--entry-text="Username"`
zenity --info\
	--text="Giving $USER administrator privileges."
usermod -aG wheel $USER 
if [ $? != 0 ] ; then
	usermod -aG sudo $USER 
elif [ $? != 0 ] ; then
	usermod -aG admin $USER 
fi
groups $USER | grep -e wheel -e admin -e sudo
if [ $? -eq 0 ] ; then
	zenity --info\
		--text="$USER now has administrator privileges"
else zenity --warning\
	--text="Adding sudo privileges failed."
fi
} 
function change_shell() { 
USER=`zenity --entry\
	--title="Change user's default shell"\
	--text="Enter username"\
	--entry-text="Username"`
SHELLS=`zenity --list\
	--title="Choose a Default Shell"\
	--width=300\
	--height=300\
	--column="Choice number" --column="Shell"\
	1 "BASH"\
	2 "C Shell"\
	3 "Z Shell"\
	4 "FISH"\
	5 "Korn Shell"`
case $SHELLS in
	1)
		usermod -s /bin/bash $USER;;
	2)
		usermod -s /usr/bin/csh $USER;;
	3)
		usermod -s /usr/bin/zsh $USER;;
	4)
		usermod -s /usr/bin/fish $USER;;
	5)
		usermod -s /usr/bin/ksh $USER;;
esac
if [ $? -eq 0 ] ; then 
	zenity --info\
	       --text="You have changed the shell of $USER"
else zenity --error\
       --text="Something has gone wrong."
fi
}
		
# Beginning of Script

if [ $(whoami) != "root" ] ; then
	gksudo 
fi

INPUT=`zenity --list \
	--title="User Maintenance Menu"\
	--width=530\
	--height=300\
	--column="Choice number" --column="Task to perform"\
	1 "List Users on the System"\
	2 "List a User's Groups"\
	3 "Add a user"\
	4 "Add a user to a group"\
       	5 "Enable or disable user's ability to login"\
	6 "Delete a user" \
	7 "Give a user sudo permissions"\
	8 "Change the user's default shell"\
	9 "Exit"`

case $INPUT in 
	1)
		list_users;;
	2)
		list_groups;;
	3)
		add_user;;
	4)
		add_group;;
	5)
		modify_access;;
	6)
		delete_user;;
	7)
		add_sudo;;
	8) 
		change_shell;;
	9)
		exit;;

esac
