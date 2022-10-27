#!/bin/bash

function ctrl_c()
{
  echo -e "\n\n[!] Saliendo...\n\n"
  #Para que me muestr el codigo de estado 1, que no es exitoso
  exit 1
}

#Ctrl + C -> Capturar el ctrl + c para redirigir el programa por la función ctrl_c
trap ctrl_c INT

#Para probar la función
#sleep 10

#Que coja el archivo que le pasemos como parametro
file_name=$1
#Entre comillas dobles para que sea una cadena y realice la función 
descompressed_file_name="$(7z l $file_name | tail -n 3 | head -n 1 | awk 'NF{print $NF}')"

7z x $file_name &>/dev/null

while [ $descompressed_file_name ]; do
  echo -e "\n[+] Nuevo archivo descomprimido: $descompressed_file_name"
  7z x $descompressed_file_name &>/dev/null
  descompressed_file_name="$(7z l $descompressed_file_name 2> /dev/null | tail -n 3 | head -n 1 | awk 'NF{print $NF}')"  
done
