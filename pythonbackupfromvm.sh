#! /bin/bash

# This script mounts a virtual machine disk image for the python projects and backs up the folders.
# It then unmounts the virtual disk image.

# Step 1: Check if user has superuser privileges

if [ $USER != root ] ; then
	echo "You must have administrative privileges to run this script."
	exit 1
fi

# Step 2: greet the user

echo "Welcome to the python development VM backup wizard.  Time to begin!"
echo ""
# Step 3: Load the NBD kernel module

echo "Loading NBD kernel module...."
echo ""
lsmod | grep nbd >> /dev/null
if [ $? -eq 1 ] ; then
	modprobe nbd
fi
echo "module loaded successfully"
echo ""

# Step 4: Turn the VM qcow2 into mountable partitions

NUM=0
LOOP=1

echo "Turning the centos.qcow2 into mountable disk partitions."
echo ""

while [ $LOOP -eq 1 ] ; do
	qemu-nbd --connect=/dev/nbd$NUM /var/lib/libvirt/images/centos-python.qcow2
	if [ $? -eq 0 ] ; then
		echo "Successfully created mountable partitions from qcow!"
		let LOOP=$LOOP+1
	elif [ $? -eq 1 ] ; then
		let NUM=$NUM+1
	#else echo "Something has gone wrong!  Alas!"
	#	exit 1
	fi
done
echo ""
# Step 5: Mount the partitions in the /mnt folder

echo "Mounting the partitions into the /mnt/ folder."
echo ""
sleep 3s
#vgchange  -ay
# partprobe
mount /dev/centos/root /mnt/mountpoint1
# Ordinarily, you'd mount the "/dev/nbd0p1" itself, but you are mounting it from a volume group called 'centos', hence the "/dev/centos/root"
if [ $? -eq 0 ] ; then
	echo "partition successfully mounted at /mnt/mountpoint1"
else echo "Something has gone wrong!  Panic!"
	exit 1
fi
echo ""
# Step 6: Synchronize the folders for the python3project folder

echo "Backing up the python 3 for system administrators stuff...."
echo ""
rsync -avz /mnt/mountpoint1/home/nicholas/Pythonstuff/python3project/ /home/nicholas/PythonScripts/python3projectbackup
if [ $? -eq 0 ] ; then
	echo "Python 3 for system administrators stuff is successfully backed up!"
else echo "Something has gone wrong backing up the python 3 for system administrators stuff"
fi
echo ""
# Step 7: Synchronize the folders for the python development folder

echo "Backing up the Python Development stuff......"
echo ""
rsync -avz /mnt/mountpoint1/home/nicholas/Pythonstuff/pythondevelopment/ /home/nicholas/PythonScripts/pythondevelopment
if [ $? -eq 0 ] ; then
	echo "Python Development stuff is successfully backed up!"
else echo "Something has gone wrong backin up the Python Development stuff!"
fi
echo ""
# Step 8: Unmount the VM partitions

echo "Unmounting the VM partitions...."
umount /mnt/mountpoint1
echo ""
# Step 9: Disable the NBD bridge for the qcow2 partitions
echo "Disabling NBD bridge for the centos.qcow2 disk partitions"
qemu-nbd --disconnect /dev/nbd$NUM

# Step 10: Say goodbye!
echo "Python development backup wizard has completed its tasks!"
echo ""
echo "We hope you have a nice day!"
