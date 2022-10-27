#!/bin/bash

echo "$(ip a | grep ens33 | tail -n 1 | awk '{print $2}')"
echo "$(ip a | grep ens33 | tail -n 1 | awk '{print $2}' | awk '{print $1}' FS='/')"
echo "$(ip a | grep ens33 | tail -n 1 | awk '{print $2}' | cut -d '/' -f 1)"
echo "$(ip a | grep ens33 | tail -n 1 | awk '{print $2}' | tr '/' ' ')"
echo "$(ip a | grep ens33 | tail -n 1 | awk '{print $2}' | tr '/' ' ' | awk '{print $1}')"

#cat /etc/networks | head -n 3 | awk '{print $2}'

file_name1="$1"
file_name2=$2

echo -e "\nEl primer archivo es: $file_name1"
echo -e "\nEl segundo archivo es: $file_name2"

funcion1="$(cat /etc/hosts)"
funcion2=$(cat /etc/hosts | tail -n 2)

echo -e "\n$funcion1"
echo -e "\n$funcion2"

