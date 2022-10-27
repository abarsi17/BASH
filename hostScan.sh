#! /bin/bash

function ctrl_c()
{
  echo -e "\n\n[!]Saliendo...\n"
  exit 1
}

trap ctrl_c INT

declare -a dir_open

dirIP=$(ifconfig ens33 | head -n 2 | tail -n 1 | awk '{print $2}' | tr '.' ' ' | awk '!($4="")' | xargs | tr ' ' '.' | xargs)

#Que el comando que esta dentro del bash -c dure un segundo
#Ponemos alfinal de esa sentencia & para que trabaje en hilos
#Wait al final para que el bucle termine cuando terminen todos los hilos
for i in $(seq 1 254); do
  timeout 1 bash -c "ping -c 1 $dirIP.$i &> /dev/null" && echo -e "[+] Host $dirIP.$i - ACTIVE" &
done; wait

