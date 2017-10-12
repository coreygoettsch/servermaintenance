#! /bin/bash

# This script simplifies a system administrator's management of users
# by automating some of the common tasks

# Global Functions

function list_users() {
echo "Listing users on this system."
echo "The format is: User Userid"
awk -F':' '$3>=1000 {print $1 " " $3}' /etc/passwd
} 
function list_groups() {
echo "Please type the name of the user."
read username
echo "The format is username: group1 group2."
groups $username
if [ $? != 0 ]; then
	echo "Something has gone wrong."
else echo "Goodbye!"
fi
}

function add_user() {
echo "Enter the Username"
read username
echo "Enter the Password" 
read -s password
echo "Creating $username..."
pass=$(perl -e 'print crypt($ARGV[0], "password")' $password) 
useradd -m -s /bin/bash -p $pass $username 
if [ $? -eq 0 ] ; then
	echo "$username created successfully!"
else echo "User not added."
fi 
} 
function add_group() { 
echo "Enter the username"
read username
echo "Enter the groupname"
read groupname
echo "adding $username to $groupname"
usermod -aG $groupname $username
if [ $? -eq 0 ] ; then
	echo "Group added successfully."
else echo "Group not added."
fi
}
function modify_access() {
echo "Would you like to add or remove the ability to login?"
echo "Type 'Add' or 'Remove'"
read login
echo "Enter username"
read username
if [ $login == "Add" ] ; then
	echo "Adding Shell Access..."
	usermod -s /bin/bash $username
elif [ $login == "Remove" ] ; then
	echo "Removing Shell Access..."
	usermod -s /usr/sbin/nologin $username
else echo "You typed something else."
fi 
if [ $? -eq 0 ] ; then
	echo  "Shell successfully changed."
else echo "Shell Access not  changed."
fi
}
function delete_user() { 
echo "Are you sure you want to delete a user?"
echo "NOTE: This action also deletes the  user's home directory"
echo "Type 'Yes' or 'No'"
read yesno
if [ $yesno == "Yes" ] ; then 
	echo "Continuing..."
else echo "Aborting."
exit 1
fi
echo "Please type the username of the user to be deleted."
read username
userdel $username && rm -rf /home/$username
if [ $? -eq 0 ] ; then
	echo "User successfully deleted."
else echo  "User deletion failed."
fi
} 
function add_sudo() { 
echo "Giving a user sudo permissions." 
echo "Please type the name of the user:"
read username
echo "Giving $username administrator privileges...."
usermod -aG wheel $username 2>/dev/null
if [ $? != 0 ] ;then 
	usermod -aG sudo $username 2>/dev/null
elif [$? != 0 ] ; then
	usermod -aG admin $username 2>/dev/null
fi
if [ $? -eq 0 ] ; then
	echo "$username has been given administrator privileges."
else echo "Something has gone wrong, and $username does not have sudo rights."
fi
}

function change_shell() {
echo "Which user's shell would you like to change?"
echo "Please type the user's name:"
read username
echo "Which shell would this user like?"
echo "1) Bash"
echo "2) C Shell"
echo "3) Z Shell"
echo "4) Fish"
echo "5) Korn Shell"
read shellchoice

case $shellchoice in
	1) 
		usermod -s /bin/bash $username;;
	2)
		usermod -s /bin/csh $username;;
	3)
		usermod -s /usr/bin/zsh $username;;
	4)
		usermod -s /usr/bin/fish $username;;
	5)
		usermod -s /usr/bin/zsh $username;;
esac
if [ $? -eq 0 ] ; then
	echo "You have changed the shell of $username"
else echo "Something has gone wrong."
fi
}

# Beginning of Script

if [ $(whoami) =  "root" ] ; then 
	echo "Welcome to the User Maintenance Program."
else echo "You must be the root user.  Goodbye."
exit 1
 
fi

echo "What action would  you like to take?" 
echo "========="
echo "1) List users on the system."
echo "2) List a user's groups."
echo "3) Add a user."
echo "4) Add a user to a group."
echo "5) Enable or disable a user's ability to login."
echo "6) Delete a user."
echo "7) Give a user sudo permissions."
echo "8) Change the user's default shell."
echo "9) Exit this program."
echo "Please Enter Your Choice:"
read menuchoice

case $menuchoice in
	
	
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
		echo "Goodbye"; exit;;
	*)
		echo "that  is not a choice."
esac
