#!/bin/bash

function ctrl_c()
{
  echo -e "\n\n[!]Saliendo...\n"
  tput cnorm
  exit 1
}

#Ctrl + c
trap ctrl_c INT

#Ocultar cursor
tput civis

for port in $(seq 1 65535); do
  (echo '' > /dev/tcp/127.0.0.1/$port) 2> /dev/null && echo -e "[+]$port - OPEN"
done;

#Mostrar cursor
tput cnorm
