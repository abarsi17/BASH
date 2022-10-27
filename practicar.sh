#!/bin/bash

function ctrl_c()
{
  echo -e "\n\n[!] Saliendo...\n"
  exit 1
}

#Ctrl + c
trap ctrl_c INT

if [ $(id | awk '{print $1}' | tr 'uid=' ' ' | tr '(' ' ' | awk '{print $1}' | xargs) == 0 ]; then
  echo -e "Es el root\n"
else
  echo -e "El usuario es $(who | awk '{print $1}')"
fi
