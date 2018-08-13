#! /bin/bash
# adminmenu.sh - This is a shell script designed to present a dialog menu of
# administration tasks, simplifying them.

#Temporary storage  file for menu  options chosen by user
INPUT=/tmp/admin.sh.$$

#Temporary storage file for displaying output
OUTPUT=/tmp/admin.sh.$$

# Trap and delete temporary files
trap 'rm $INPUT; rm $OUTPUT; exit' SIGHUP SIGINT SIGTERM

# This function displays output through msgbox
function display_output(){
	local h=${1-10} #Default box height 10
	local w=${2-41} #Default box width 41
	local t=${3-Output} #Box title
	dialog --backtitle "Administration Tasks" --title "${t}" --clear --msgbox "$(<$OUTPUT)" ${h} ${w}  
}  

#This function displays 

function show_backup(){
	tar -cf websitebackup.tar /var/www/
	echo "/var/www/ successfully backed up.">$OUTPUT 
	display_output 10 30 "Backup"
}

TODAYSDATE=`date`

function show_update(){
	yum update -y ## This is for CentOS 7 and older RPM-based systems using YUM
	# apt-get update && apt-get upgrade -y #This is Debian-based systems 
	# dnf update -y #This is for newer RPM systems using DNF
	# pacman -Syu #This is for arch-based systems but should be used with cautiion as it contains bleeding-edge software
	echo "Software Updates Run.">$OUTPUT
	display_output 10 30 "Updates"
}

function do_aide(){
	aide --check 
	echo "This AIDE was successfully run.">$OUTPUT
	display_output 10 30 "AIDE"



# set infinite loop
while true 
do

# The main menu
dialog --clear --help-button --backtitle "System Administration Help Tool" \
--title "Main Menu" \
--menu "You can use the Up and Down arrow keys, the first \n\
letter of the choice as a hot key, or the \n\
number keys 1-9 to choose an option.\n\
Choose the TASK" 30 50 2 \
Backup "Backs up the web directory" \
Update "Updates Software on the System" \
Aide "Runs AIDE intrustion check" \
Exit "Exits to the shell" 2>"${INPUT}"

menuitem=$(<"${INPUT}") 

#make decision
case $menuitem in
	Backup) show_backup;;
	Update) show_update;;
	Aide) do_aide;;
	Exit) echo "Bye"; break;;

esac

done
