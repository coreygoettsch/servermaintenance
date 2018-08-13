#! /bin/bash
#This script makes it easier to mount a partition from a virtual machine disk.

if [ $USER != "root" ] ; then
	zenity --warning \
		--text="You need to have administrative privileges to run this script."
	exit
fi

zenity --info --text="This is a utility for mounting virtual disk partitions."
zenity --warning --text="This script requires the 'qemu-nbd' package.  Please make sure it's installed before proceeding."
zenity --question --text="Would you like to proceed?"

if [ $? == 1 ] ; then
	exit
fi

function mount_virtdiskpart() {
lsmod | grep nbd >> /dev/null #This checks if the nbd kernel module is loaded, and if it's not, it loads it.
if [ $? == 1 ] ; then
	modprobe nbd
fi

zenity --info --text="Please select a virtual disk image"
FILE=`zenity --file-selection`
zenity --info --text="Your virtual disk partitions will be mounted in the /mnt folder at folders called 'mountpoint1', with folder numbers corresponding to partition numbers."

qemu-nbd --connect=/dev/nbd0 $FILE
ls /dev >> /tmp/devlist.txt
CHOICE=`grep nbd0p /tmp/devlist.txt`
for p in $CHOICE ; do
	ls /mnt/mountpoint${p: -1} 2>> /dev/null
		if [ $? != 0 ] ; then
			mkdir /mnt/mountpoint${p: -1}
		fi
	mount /dev/$p /mnt/mountpoint${p: -1}
	rm -f /tmp/devlist.txt
	done
#TODO: Insert a test that checks if all partitions are mounted properly and throws an error message if they're not..
zenity --info --text="Virtual disk partitions successfully mounted."
}
function unmount_virtdiskpart() {
ls /dev >> /tmp/devlist.txt
CHOICE=`grep nbd0p /tmp/devlist.txt`
for p in $CHOICE ; do
	umount /mnt/mountpoint${p: -1}
	done
qemu-nbd --disconnect /dev/nbd0
rmmod nbd
rm -f /tmp/devlist.txt
#TODO: A test to see if all partitions are unmounted, nbd devices are disconnected and nbd module is unloaded from kernel
zenity --info --text="Virtual disk partitions unmounted successfully.  You may now use VM again."
}
ACTION=`zenity --list --title="Would you like to mount or unmount a virtual disk?" --column="Action" Mount Unmount Cancel --width=500 --height=150`

case $ACTION in
	Mount)
		mount_virtdiskpart;;
	Unmount)
		unmount_virtdiskpart;;
	Cancel)
		exit;;
esac
