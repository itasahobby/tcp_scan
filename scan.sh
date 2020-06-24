#!/bin/bash

#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;90m\033[1m"

if [ -z $1 ]
then
	echo -e "${redColour}[*]Syntax: scan ip${endColour}"
	exit 1
fi

SECONDS=0

echo -e "${redColour}[*] OS based on TTL${endColour}"

ttl=$(timeout 3 ping -c 1 $1 | head -2 | tail -1 | cut -d " " -f6 | tr -d "ttl=")

if [ -z $ttl ]
then
	echo "Couldn't reach the host"
elif [[ $ttl -ge 33 && $ttl -le 64 ]]
then
        echo Linux
elif [[ $ttl -ge 65 && $ttl -le 128 ]]
then
	echo Windows
elif [[ $ttl -ge 129 && $ttl -le 255 ]]
then
	echo Cisco
else
	echo Unknown OS
fi

ttl_time=$SECONDS

if [ -z $ttl_time ]
then
	$ttl_time=0
fi

echo -e "${redColour}[*] TCP Scan${endColour}"

furious=$(/root/go/bin/furious -s connect -p 1-65535 $1 | grep "/tcp" | cut -d "/" -f1 | tr -d "\t" | sed -e 'H;${x;s/\n/,/g;s/^,//;p;};d')

furious_time=$(($SECONDS - $ttl_time))

echo -e "${yellowColour}Open ports: $furious${endColour}"

nmap -sC -sV -Pn -T4 -n -p$furious $1 | tail -n+5 | head -n-3

nmap_time=$(($SECONDS - $furious_time))

if [ -z $nmap_time ]
then
	$nmap_time=0
fi

total_time=$SECONDS
echo -e "${grayColour}[*] Execution time:\n\t TTL:$ttl_time\n\t Port scan:$furious_time\n\t Nmap:$nmap_time\n\t Total:$total_time${endColour}"

