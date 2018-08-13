#! /bin/bash

#This script automates the creation, formatting, and mounting of an encrypted filesystem.

# This script requires zenity

#sudo test 

if  [ $USER != "root" ] ;  
	then zenity --warning\
	--title="Must Be Root"\
	--text="You must be root to run this script"\
	exit
fi


# Functions 

function check_exitcode () {
	if [ $? -eq 0 ] ; 
	then zenity --info\
		--title="Success"\
		--text="$1 has completed successfully"
	else zenity --warning\
		--title="Failure!"\
		--text="$1 has failed!:"
fi
}

function create_luksfile () {
SIZE=`zenity --entry\
	--title="Size of LUKS"\
	--text="Enter Size of Partition in megabytes(1, 10, 100, 1000)"\
	--entry-text="size in megabytes"`
NAME=`zenity --entry\
	--title="Name of luksfile"\
	--text="Enter name of luksfile"\
	--entry-text="name"`
dd if=/dev/zero of=/$NAME count=$SIZE bs=1048576

check_exitcode "allocating luksfile"

}

function makeluks() {
zenity --info\
	--title="Creating"\
	--text="Creating Luksfile"
cryptsetup luksFormat /$NAME

check_exitcode "creating luksfile"

}

function openluks () {
	zenity --info\
		--title="Opening"\
		--text="Opening Luksfile"
	cryptsetup luksOpen /$NAME $NAME

check_exitcode "opening luksfile"

}

function formatluksfilesystem () {
	FILESYSTEM=`zenity --list\
		--title="Choose Filesystem Format"\
		--column="Format"\
		xfs\
		ext3\
		ext4\
		ntfs\
		msdos`
	mkfs.$FILESYSTEM /dev/mapper/$NAME

check_exitcode "formatting filesystem"	
}

function mountluksfile () {
	zenity --info\
		--title"Mounting...."\
		--text="Mounting luks filesystem"
	ls /mnt/$NAME
	if [ $? -ne 0 ] ; then
	mkdir /mnt/$NAME
	check_exitcode "creating mountpoint"
	fi
	mount /dev/mapper/$NAME /mnt/$NAME
	check_exitcode "mounting luks filesytem"

}

function unmountluksfile () {
	zenity --info\
		--title"Unmounting...."\
		--text="Unmounting luks filesystem"
	umount /mnt/$NAME
	check_exitcode "unmounting luks filesystem"
}

function automountluksfile () {
	zenity --info\
		--title="Automounting"\
		--text="Automounting luksfilesystem"
	ls -l /mnt/$NAME
	if [ $? -ne 0 ] ; then 
	mkdir /mnt/$NAME
	fi
	echo "/$NAME	/mnt/$NAME	$FILESYSTEM	defaults	0	0" >> /etc/fstab
	mount -a
	if [ $? -eq 0 ] ; then
		zenity --info\
			--title="Success"\
			--text="Luks filesystem successfully added to /etc/fstab"
	else sed '$d' /etc/fstab
	zenity --warning\
		--title="Failure"\
		--text="Failure adding luks filesystem to /etc/fstab"
	fi
}
function closeluksfile () {
	zenity --info\
		--title="Closing luksfile"\
		--text="Closing and encrypting luksfile"
        cryptsetup luksClose $NAME
	check_exitcode "closing and encrypting luksfile"       
}	

# set infinite loop
#while true
#do


# Main Menu

INPUT=`zenity --list\
	--title="Luks Management Menu"\
	--width=530\
	--height=300\
	--column="Number" --column="Task to Perform"\
	1 "Create a LUKS file"\
	2 "Open a Luks file"\
	3 "Format Luks file filesystem"\
	4 "Mount luks filesystem"\
	5 "Automatically mount a luks filesystem"\
	6 "Unmount luks filesystem"
	7 "Close a luks filesystem"\
	8 "Exit"`

case $INPUT in
	1)
		create_luksfile makeluks;;
	2)
		openluks;;
	3)
		formatluksfilesystem;;
	4)
		mountluksfile;;
	5)
		automountluksfile;;
	6) 
		unmountluksfile;;
	7)
		closeluksfile;;
	8) 
		exit;;
esac

