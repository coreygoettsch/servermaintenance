#! /bin/bash

# This script checks to see if any packages ask for a system reboot.  If they do, then it restarts the system.  

find /var/run/ -name "reboot-required" | tee /root/restart.txt 
grep "reboot-required" /root/restart.txt 
if [ $? -eq 0 ] ; then
	rm /root/restart.txt
	reboot 
fi
