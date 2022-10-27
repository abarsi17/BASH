#!/bin/bash

function ctrl_c()
{
  echo -e "\n\n[!] Saliendo...\n"
  exit 1
}

trap ctrl_c INT

#Antes darle permisos de ejecución al archivo
#chmod +x script.sh

cat /etc/bandit_pass/bandit24 > /var/spool/bandit24/foo/pass.txt  

