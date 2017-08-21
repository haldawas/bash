#!/bin/bash

#Please before you start testing this script, make sure to download all BASH folder contents into your home directory OR change your command directory to the BASH folder for a smooth script execution

#main function

main() {
type_something $@ #This to make sure an input is given by the user
}

#This function will make sure that the user didn't press enter without writing an argument, if so it will notify the user

type_something() {

user=$(whoami) #saves whoami's output in user variable
printf "\nHello $user \n\n"
if [ $# -lt 1 ];then #Input validation
	echo "Please run the script again with an input" 
	echo "For help type ./bashfinal.sh -h"
#all other cases run functions according to the user's input
elif [ $@ == "-h" ];then
	help
elif [ $@ == "-ping" ];then
	pinging
elif [ $@ == "-iptoname" ]; then
	iptoname
elif [ $@ == "-nametoip" ]; then
	nametoip
elif [ $@ == "-hashit" ]; then
	hashit
elif [ $@ == "-filehash" ]; then
	filehash
elif [ $@ == "-intig" ]; then
	intig
elif [ $@ == "-filestat" ]; then
	filestat
elif [ $@ == "-guess" ]; then
	guess
else
	echo "Please enter a valid option"
fi
}

#This function is the manual of the script, runs when -h option is used

help() {
printf "\n"
echo "Welcom to bashfinal.sh manual page"
printf "\n"
echo "This script is designed to combine several useful functions which can be accessed through options"
printf "\n"
echo "These are the available options:"
printf "\n\t"
echo "-h to show this help page"
echo "Ex: ./bashfinal.sh -h"
printf "\n\t"
echo "-pinging to ping google's DNS server and check internet connectivity"
echo "Ex: ./bashfinal.sh -pinging"
printf "\n\t"
echo "-iptoname to resolve an ip address to a host name"
echo "Ex: ./bashfinal.sh -iptoname"
printf "\n\t"
echo "-hashit This option is used to hash anything typed by the user"
echo "Ex: ./bashfinal.sh -hashit"
printf "\n\t"
echo "-filehash This option is used to hash any file"
echo "Ex: ./bashfinal.sh -filehash"
printf "\n\t"
echo "-intig This option is used to verify that the script hasn't change since publishement"
echo "Ex: ./bashfinal.sh -intig"
printf "\n\t"
echo "-filestat option show different statistics about a given file"
echo "Ex: ./bashfinal.sh -filestat"
printf "\n\t"
echo "-guess When coding gets you frustrated you can have a break playing this game"
echo "Ex: ./bashfinal.sh -guess"
printf "\n"
}

# This function will ping 8.8.8.8 to check if the machine is connected to the Internet

pinging() {
ping_target=8.8.8.8
echo "==================== Pinging $ping_target ===================="
printf "\n"
ping -c1 $ping_target >/dev/null #run ping of one packet to 8.8.8.8 and suprress output
RESULT=$?
if [ $RESULT -eq 0 ]; then
	echo "You are connected to the internet"
	printf "\n"
else
	echo "You are not connected to the internet"
	printf "\n"
fi
}

# This function will use nslookup to reslolve an ip address to its host name
iptoname() {
echo "==================== Translate IP to Hostname ===================="
printf "\n"
read -p 'Enter the ip address that you want to resolve: ' INPUT
if [[ $INPUT =~ ^[0-9]+\.[0-9]+\.[0-9]\.[0-9]+$ ]]; then
	OUTPUT="$(nslookup $INPUT | grep name)"
	echo $OUTPUT
	printf "\n"
else
	echo "Please enter a valid IP Address"
	iptoname
fi
}

#This function will take what ever the user has typed and generate an md5 hash of it
hashit() {
echo "==================== Hash User Input ===================="
printf "\n"
read -p 'Type or copy and paste whatever you want to hash: ' DATA
digest=($(md5sum <<< $DATA))
echo "The md5 hash digest of $DATA is:"
echo $digest
printf "\n"
}

#This fuction will take any file and generate an md5 hash of it
filehash() {
echo "==================== Hash The File ===================="
printf "\n"
read -p 'Type the file name that you want to hash: ' FILE
digest=($(md5sum $FILE))
echo "The md5 hash of $FILE is:"
echo $digest
printf "\n"
}

#This function hashes the script then compares the hash to a stored value to confirm that the script hasn't change since publishement

intig() {
echo "==================== Check Script Intigrity ===================="
printf "\n"
digest1=($(md5sum bashfinal.sh))
digest2=`cat bashfinaldigest.txt`

if [ "$digest1" == "$digest2" ]; then
	echo "The Script hasn't changed since publishement"
	printf "\n"
else
	echo "Becareful, Someone chaged the script since publishement"
	printf "\n"
fi
}

#Lists different stats of a file(#lines,#words,#characters,#bytes and maximum line length)
filestat() {
echo "==================== File Statistics ===================="
printf "\n"
read -p 'Please type the file name: ' FILE
LINES=($(wc -l $FILE))
WORDS=($(wc -w $FILE))
CHARS=($(wc -m $FILE))
BYTES=($(wc -c $FILE))
MXLNL=($(wc -L $FILE))

printf "\n"
echo "Number of lines: $LINES"
echo "Number of words: $WORDS"
echo "Number of characters: $CHARS"
echo "Number of bytes: $BYTES"
echo "Length of the longest line: $MXLNL"
printf "\n"

}

#a guessing game that will tell the user if the number is more or less than what he typed until he gets the number
guess() {
echo "==================== Have Fun ===================="
printf "\n"
x=($(shuf -i 0-1000 -n 1)) #create a random number from 0 to 1000
echo "Guess the number"
read y
while [ y != x ]; do #loop while user input doesn't equal the random number x)
	if [ $y -lt $x ]; then
		echo "More"
		echo "Guess the number"
		read y
	elif [ $y -gt $x ]; then
		echo "Less"
		echo "Guess the number"
		read y
	else
		echo "You got it!"
		printf "\n"
		exit
	fi
done
}



main $@
