#! /bin/bash

# This script automates adding a users and enabling SSH hardening for
# Digital Ocean servers with SSH key as default login method.

#Introduction
echo "Welcome to the Digital Ocean server initialization script."
echo "What we're going to do is install some cool packages, create a new user,"
echo "give that user sudo permissions, harden ssh for ssh authentication only,"
echo "update the system, and reboot."
echo "So let's get started with changing your root password."
# Change root password
echo "Please enter a new root password"
passwd # change root user password


#Test if server is centos or ubuntu
uname -a > distrotest.txt #records from uname output that determines whether it is ubuntu or centos
grep centos distrotest.txt >> /dev/null

#Install cool packages
if [ $? == 0 ] #what to do if centos
  then
    yum install epel-release -y #add epel repository for centos
    yum install vim nmon fail2ban  -y # install the cool packages
  else #what to do if ubuntu
    apt-get update #update repository for ubuntu
    apt-get install -y nmon fail2ban #add cool packages for ubuntu
fi
# Start and enable fail2ban ssh brute force security
# systemctl start fail2ban && systemctl enable fail2ban
# Create user
echo "What is the name of the user you would like to create?"
read USERNAME
adduser $USERNAME
grep centos distrotest.txt >> /dev/null #ensure user password changed if centos
if [ $? == 0 ]
  then
    passwd $USERNAME #manually change password for user
fi
# Give user sudo permissions
grep centos distrotest.txt >> /dev/null  #test for centos or ubuntu
if [ $? == 0 ]
  then
    usermod -aG wheel $USERNAME #add user to group wheel if centos
  else
    usermod -aG sudo,admin $USERNAME #add user to groups sudo and admin if ubuntu
fi
#Copy ssh public key from root to the new user
cp -rf /root/.ssh /home/$USERNAME/
#Change ownership of new user's .ssh folder to the user
chown -R $USERNAME:$USERNAME /home/$USERNAME/.ssh
# Test if PermitRootLogin option is enabled in /etc/ssh/sshd_config
grep 'PermitRootLogin yes' /etc/ssh/sshd_config >> /dev/null
#If it is enabed, then disable it
if [ $? == 0 ]
 then
  sed 's/PermitRootLogin\ yes//g' /etc/ssh/sshd_config >> /etc/ssh/sshd_config.backup #delete PermotRootLogin yes and create backup file of ssh_config
  rm /etc/ssh/sshd_config # delete sshd_config file
  mv /etc/ssh/sshd_config.backup /etc/ssh/sshd_config #Rename sshd_config.backup to sshd_config
  echo "PermitRootLogin no" >> /etc/ssh/sshd_config #Write PermitRootLogin yes to sshd_config
  systemctl restart sshd # restart ssh daemon to enable cahnges
fi
# Upgrade packages
grep centos distrotest.txt >> /dev/null
if [ $? == 0 ]
  then
    yum update -y #upgrade packages for centos
  else
    apt-get upgrade -y #upgrade packages for ubuntu
fi
rm -f distrotest.txt >> /dev/null
echo "Server setup complete.  Rebooting now."
reboot
