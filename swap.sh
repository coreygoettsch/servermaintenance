#! /bin/bash

#This script automates the creation, formatting, and mounting of swap files.
# This script requires zenity
#sudo test 

if  [ $USER != "root" ] ;  
	then zenity --warning\
	--title="Must Be Root"\
	--text="You must be root to run this script"\
	exit
fi


# Functions 

function create_swapfile () {
SIZE=`zenity --entry\
	--title="Size of Swapfile"\
	--text="Enter Size of Swapfile(e.g. 100KB, 100MB, 1GB)"\
	--entry-text="size"`
NAME=`zenity --entry\
	--title="Name of Swapfile"\
	--text="Enter name of Swapfile"\
	--entry-text="name"`
dd if=/dev/zero of=/$NAME bs=$SIZE 

if [ $? -eq 0 ] ; then
	zenity --info\
		--title="Success"\
		--text="Swapfile successfully created"
else zenity --warning\
	--title="Failure"\
	--text="Swapfile not created"
fi
}

function makeswap() {
zenity --info\
	--title="Formatting"\
	--text="Formatting Swapfile"
mkswap /$Swapfile

if [ $? -eq 0 ] ; then 
	zenity --info\
		--title="Success"\
		--text="Swapfile successfully formatted"
	else zenity --warning\
		--title="Failure"\
		--text="Swapfile formatting has failed."
fi
chmod 0600 /$Swapfile
}
function activateswap () {
	zenity --info\
		--text="Activating"\
		--text="Activating Swapfile"
	swapon /$Swapfile

