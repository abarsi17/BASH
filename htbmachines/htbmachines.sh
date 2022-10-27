#!/bin/bash

#Para modificar los colores de las palabras
source colores.ini
#Variables globales
url_main="https://htbmachines.github.io/bundle.js"


function ctrl_c()
{
  echo -e "\n\n${redColour}[!] Saliendo...${endColour}\n"
  exit 1
}

#Ctrl_c
trap ctrl_c INT

function searchMachine()
{
  #Lo ponemos entre dobles comillas para que lo trate como un string
  machineName="$1"
  if [ "$machineName" ]; then
    echo -e "\n\n${yellowColour}[+]${endColour} Listando las propiedades de la máquina ${blueColour}$machineName${endColour}:\n"
    cat bundle.js | awk "/name: \"$machineName\"/,/resuelta:/" | grep -vE "id|sku|resuelta" | tr -d '"' | sed "s/^ *//"
  else
    echo -e "\n\n${redColour}[!] La máquina no existe${endColour}\n"
  fi
}

function helpPanel()
{
  echo -e "\n${purpleColour}[+]${endColour} ${grayColour}Panel de ayuda:${endColour}"
  echo -e "\t${yellowColour}u)${endColour} ${grayColour}Para descargar o actualizar el archivo${endColour}"
  echo -e "\t${yellowColour}m)${endColour} ${grayColour}Para buscar maquinas por el nombre${endColour}"
  echo -e "\t${yellowColour}i)${endColour} ${grayColour}Para buscar maquinas por la dirección IP${endColour}"
  echo -e "\t${yellowColour}y)${endColour} ${grayColour}Para buscar el link a la resolución de la máquina${endColour}"
  echo -e "\t${yellowColour}d)${endColour} ${grayColour}Para buscar maquinas por la dificultad (Fácil, Media, Difícil, Insane)${endColour}"
  echo -e "\t${yellowColour}o)${endColour} ${grayColour}Para buscar maquinas por el sistema operativo${endColour}"
  echo -e "\t${yellowColour}d , o)${endColour} ${grayColour}Para buscar maquinas por la dificultad y el sistema operativo${endColour}"
  echo -e "\t${yellowColour}h)${endColour} ${grayColour}Para acceder a este menu${endColour}"
  echo -e "\t${yellowColour}s)${endColour} Para buscar por skills"
}

function updateFile()
{
  echo -e "\n${yellowColour}[+]${endColour} Actualizando o descargando fichero"

  #Que el fichero no exista
  if [ ! -f bundle.js ]; then
    curl -s -X GET $url_main > bundle.js
    cat bundle.js | js-beautify | sponge bundle.js
  else 
    curl -s -X GET $url_main > bundle_tmp.js
    cat bundle_tmp.js | js-beautify | sponge bundle_tmp.js
    #Entre dobles comillas para que lo interprete como un string
    md5sum_value="$(md5sum bundle.js | awk '{print $1}')" 
    md5sum_valueTmp="$(md5sum bundle_tmp.js | awk '{print $1}')"

    if [ $md5sum_value == $md5sum_valueTmp ]; then
      echo -e "\n\n${yellowColour}[+]${endColour} ${grayColour}No se han detectado actualizaciones${endColour}\n"
      rm bundle_tmp.js
    else
      echo -e "\n\n${yellowColour}[-]${endColour} ${grayColour}Se ha detectado una actualizacion${endColour}"
      echo -e "\n\n${yellowColour}[+]${endColour} ${grayColour}Actualizando...${grayColour}\n"
      sleep 2
      rm bundle.js
      mv bundle_tmp.js bundle.js
    fi
  fi
}

function searchIP()
{
  ipAddress=$1
  machineName="$(cat bundle.js | grep "ip: \"$ipAddress\"" -B 3 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',')"

  if [ ! "$machineName" ]; then
    echo -e "\n\n${redColour}[!] La dirección IP proporcionada no existe${endColour}\n"
  else 
    echo -e "\n\n${yellowColour}[+]${endColour} La máquina con la IP ${purpleColour}$ipAddress${endColour} es ${blueColour}$machineName${endColour}\n"
  fi
}

function getYoutubeLink()
{
  machineName="$1"
  linkYoutube="$(cat bundle.js | grep "name: \"$machineName\"" -A 10 | grep "youtube: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',')"
  if [ ! "$linkYoutube" ]; then 
    echo -e "\n\n${redColour}[!] La máquina proporcionada no existe${endColour}\n"
  else 
    echo -e "\n\n${yellowColour}[+]${endColour} El link de la resolución de la máquina ${purpleColour}$machineName${endColour} es ${blueColour}$linkYoutube${endColour}\n"
  fi
}

function getMachineDifficulty()
{
  difficulty="$1" 
  getMachines="$(cat bundle.js | grep -i "dificultad: \"$difficulty\"" -B 10 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column)"

  if [ ! "$getMachines" ]; then
    echo -e "\n\n${redColour}[!] La dificultad está mal escrita\n"
  else
    echo -e "\n\n${yellowColour}[+]${endColour} Estas son las máquinas con la dificultad ${purpleColour}$difficulty${endColour}\n"
    echo -e "$getMachines"
  fi
}

function getMachinesOS()
{
  os="$1"
  machinesOS="$(cat bundle.js | grep -i "so: \"$os\"" -B 5  | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column)"
  if [ ! "$machinesOS" ]; then
    echo -e "\n\n${redColour}[!] El SO no existe\n"
  else
    echo -e "\n\n${yellowColour}[+]${endColour} Estas son las máquinas con el sistema operativo: ${purpleColour}$os${endColour}\n"
    echo -e "$machinesOS"
  fi
}

function bothFunction()
{
  difficulty="$1"
  os="$2"
  machines="$(cat bundle.js | grep "dificultad: \"$difficulty\"" -B 5 | grep "so: \"Linux\"" -B 5 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column)"
  machinesOS="$(cat bundle.js | grep -i "so: \"$os\"" -B 5  | grep "name: ")"

  if [ ! "$machines" ]; then
    if [ ! "$machinesOS" ]; then
      echo -e "\n\n${redColour}[!] El SO no existe\n"
    else
      echo -e "\n\n${redColour}[!] La dificultad está mal escrita\n"
    fi
  else 
    echo -e "\n\n${yellowColour}[+]${endColour} Estas son las máquinas con el sistema operativo ${purpleColour}$os${endColour} y dificultad ${purpleColour}$difficulty${endColour}:\n"
    echo "$machines"
  fi
}

function getSkills()
{
  skills="$1"
  getSkills="$(cat bundle.js | grep "skills: " -B 7 | grep -i "sqli" -B 7 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column)"
  if [ ! "$getSkills" ]; then
      echo -e "\n\n${redColour}[!] La skill no existe o está mal escrita\n"
  else
    echo -e "\n\nLas máquinas con la skill ${purpleColour}$skills${endColour}:\n"
    echo "$getSkills"
  fi
}

#Indicadores, se pone -i para indicar que es un entero
declare -i parameter_counter=0

declare -i var_difficulty=0
declare -i var_os=0

#Las opciones del switch {m y h}
#m: -> se ponen los dos puntos para hacer referncia a que se la pasa un parametro
#h -> que no se le pasa ningun parametro a "h"
#Menu getopts que nos permite alternar entre una serie de funciones existentes
while getopts "m:ui:y:hs:o:d:" arg; do
  case $arg in
    #Para almacenar el argumento que le pasemos al parametro. Ejemplo ./htbmachines.sh -m "Maquina" -> OPTARG almacenara Maquina
    #Hay que poner el guion sino, no interpretara que le estamos pasando el parametro correcto
    m) machineName=$OPTARG; let parameter_counter+=1;;
    u) let parameter_counter+=2;;
    y) machineName=$OPTARG; let parameter_counter+=4;;
    i) machineIP=$OPTARG; let parameter_counter+=3;;
    d) difficulty=$OPTARG; let var_difficulty+=1; let parameter_counter+=5;;
    o) os=$OPTARG; let var_os+=1; let parameter_counter+=6;;
    s) skills=$OPTARG; let parameter_counter+=7;;
    h) ;;    
  esac
done

if [ $parameter_counter -eq 1 ]; then
  searchMachine $machineName
elif [ $parameter_counter -eq 2 ]; then
  updateFile
elif [ $parameter_counter -eq 3 ]; then
  searchIP $machineIP
elif [ $parameter_counter -eq 4 ]; then
  getYoutubeLink $machineName
elif [ $parameter_counter -eq 5 ]; then
  getMachineDifficulty $difficulty
elif [ $parameter_counter -eq 6 ]; then
  getMachinesOS $os
elif [ $var_difficulty -eq 1 ] && [ $var_os -eq 1 ]; then
  bothFunction $difficulty $os
elif [ $parameter_counter -eq 7 ]; then
  getSkills "$skills"
else
  helpPanel
fi
