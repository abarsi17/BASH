#!/bin/bash

# Archivo donde se almacenan los colores
source colores.ini

# Función cuando se pulsa Ctrl + C
function ctrl_c()
{ 
  echo -e "\n\n${redColour}[!] Saliendo...${endColour}\n"
  exit 1
}

# Ctrl + C
trap ctrl_c INT

# Función de ayuda para que te muestre lo que hace el script
function helpPanel()
{
  echo -e "\n${purpleColour}[+]${endColour} Panel de ayuda:"
  echo -e "\t${yellowColour}-m${endColour} Para indicar el dinero que queremos apostar"
  echo -e "\t${yellowColour}-t${endColour} Para indicar la técnica que queremos apostar (${yellowColour}martingala${endColour}/${yellowColour}inverseLabouchere${endColour})"
  echo -e "\t${yellowColour}-h${endColour} Este panel de uso"
}

# Función de la técnica Martingala
function martingala()
{
  echo -e "\n${yellowColour}[+]${endColour} Dinero actual: ${purpleColour}$money${endColour}"
  echo -ne "${yellowColour}[+]${endColour} ¿Cuánto dinero tienes pensado apostar? -> " && read initial_bet
  echo -ne "${yellowColour}[+]${endColour} ¿A qué deseas apostar (par/impar)? -> " && read par_impar
 
  echo -e "${yellowColour}[+]${endColour} Vamos a jugar con la cantidad inicial de ${purpleColour}$initial_bet${endColour}€ a ${purpleColour}$par_impar${endColour}"
 
  backup_bet=$initial_bet
  games_counter=0
  max_money=$money
  jugadas_malas="[ "
  # Bucle infinito
  while true; do
    money=$(($money-$initial_bet))
   # Mayor igual que    
    if [ "$money" -ge 0 ]; then
      echo -e "\n${yellowColour}[+]${endColour} Apostamos ${purpleColour}$initial_bet${endColour}€ tienes ${purpleColour}$money${endColour}€"
    
      # Obtener un número random entre 0 y 36 ambos inclusivos
      random_number="$(($RANDOM % 37))"

      echo -e "${yellowColour}[+]${endColour} Ha salido el número ${blueColour}$random_number${endColour}" 
      if [ "$par_impar" == "par" ]; then 
        if [ "$(($random_number % 2))" -eq 0 ]; then
          if [ "$random_number" -eq 0 ]; then
            echo -e "${redColour}[+] El número es 0, ¡has perdido!${endColour}"
            initial_bet=$(($initial_bet * 2))
            jugadas_malas+="$random_number "
          else
            echo -e "${greenColour}[+] El número es par, ¡has ganado!${endColour}"
            money=$(($money + $initial_bet * 2))
            initial_bet=$backup_bet
            jugadas_malas="[ "

            # Que el dinero que tengo sea mayor que la máxima ganancia obtenida
            if [ $money -gt $max_money ]; then
              max_money=$money  
            fi
          fi
        else
          echo -e "${redColour}[+] El número es impar, ¡has perdido! ${endColour}"
          initial_bet=$(($initial_bet * 2))
          jugadas_malas+="$random_number "
        fi
      else # Que la apuesta inicial sea al impar
        if [ "$(($random_number % 2))" -eq 0 ]; then
          echo -e "${redColour}[+] El número es par, ¡has perdido!${endColour}"
          initial_bet=$(($initial_bet * 2))
          jugadas_malas+="$random_number "
        else
          echo -e "${greenColour}[+] El número es impar, ¡has ganado! ${endColour}"
          money=$(($money + $initial_bet * 2))
          initial_bet=$backup_bet
          jugadas_malas="[ "
          # Que el dinero que tengo sea mayor que la máxima ganancia obtenida
          if [ $money -gt $max_money ]; then
            max_money=$money
          fi
        fi
      fi
    else
#     echo -e "\n\n${turquoiseColour}[!] No puedes realizar esa apuesta!!!${endColour}"
#     echo -e "${yellowColour}[+]${endColour} Tu dinero actual es ${greenColour}$money${endColour}€\n"
      jugadas_malas+="]"
      echo -e "\n\n${yellowColour}[+]${endColour} Has relizado un total de ${blueColour}$games_counter${endColour} jugadas"
      echo -e "${yellowColour}[+]${endColour} La máxima ganancia obtenida ha sido ${greenColour}$max_money${endColour}€"
      echo -e "${yellowColour}[+]${endColour} Las jugadas malas consecutivas son ${greenColour}$jugadas_malas${endColour}"
      exit 0
    fi

    ((games_counter++))
  done
}

function auxInvLabouchere()
{
    # Si es 0, es que el número que ha salido es contrario a lo que jugamos
    if [ $1 -eq 0 ]; then
      if [ ${#my_sequence[@]} -ge 2 ]; then
        # Borrar el primer y último elemento de la array
        unset my_sequence[0]
        unset my_sequence[-1]
      
        # Que el tamaño es mayor que 0
        if [ ${#my_sequence[@]} -ge 2 ]; then
          # Recolocar la array para que no se queden la primera y última posición vacías
          my_sequence=(${my_sequence[@]})
          
          # Sumar primer y último elemento de la array
          let bet=$((${my_sequence[0]} + ${my_sequence[-1]}))

        elif [ ${#my_sequence[@]} -eq 1 ]; then
          my_sequence=(${my_sequence[@]})
          let bet=${my_sequence[@]}
        
        else
          my_sequence=(${my_sequence_bkp[@]})
          let bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
        fi
      
      # Que haya un elemento
      else
        unset my_sequence[0]
        my_sequence=(${my_sequence_bkp[@]})
        let bet=5
      
      fi
    # Diferente de 0, que el número que ha salido cumple con lo que hemos apostado 
    else
      my_sequence+=($bet)
      let reward=$(($bet * 2))
      let money=$(($money + $reward))
      if [ $money -gt $max_money ]; then
        max_money=$money
      fi
      bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
    fi 
}


function inverseLabouchere()
{
  let games_counter=0
  let max_money=$money
  # Declarar un array
  declare -a my_sequence=(1 2 3 4)
  # Realizar una copia de la array
  my_sequence_bkp=(${my_sequence[@]})

  echo -e "\n${yellowColour}[+]${endColour} Dinero actual: ${yellowColour}$money${endColour}"
  echo -ne "${yellowColour}[+]${endColour} ¿A qué deseas apostar (par/impar)? -> " && read par_impar
  
  # Mostrar la cantidad de elementos de la array
#   echo ${#my_sequence[@]}
  bet=5
  bet_to_renew=$(($money + 50)) 
  while true; do
    
    if [ $money -gt $bet_to_renew ]; then
      echo -e "\n${yellowColour}[+]${endColour} Restablecemos la secuencia, ya que hemos llegado al tope establecido"
      my_sequence=(${my_sequence_bkp[@]})
      bet_to_renew=$(($bet_to_renew + 50))
      echo -e "${yellowColour}[+]${endColour} Restablecemos el tope hasta ${purpleColour}$bet_to_renew${endColour}"
      bet=5
    fi
    echo -e "\n${yellowColour}[+]${endColour} Tenemos ${yellowColour}$money${endColour}€"
    echo -e "${yellowColour}[+]${endColour} Utilizaremos la siguiente secuencia ${greenColour}[${my_sequence[@]}]${endColour}"
    echo -e "${yellowColour}[+]${endColour} Vamos a jugar con la cantidad inicial de ${yellowColour}$bet${endColour}€ a ${purpleColour}$par_impar${endColour}"
    money=$(($money - $bet))
    echo -e "${yellowColour}[+]${endColour} Se nos queda ${yellowColour}$money${endColour}€, después de apostar."

    if [ $money -gt 0 ]; then
      random_number=$((RANDOM % 37))
      echo -e "\n${yellowColour}[+]${endColour} Ha salido el ${purpleColour}$random_number${endColour}"
      if [ $par_impar == "par" ]; then
        if [ $(($random_number % 2)) -eq 0 ]; then
          if [ $random_number -eq 0 ]; then
            echo -e "${redColour}[!] Ha salido el 0, ¡Has perdido!${endColour}"
            auxInvLabouchere 0
          else
            echo -e "${greenColour}[+] Ha salido par, ¡Has ganado!${endColour}"
            auxInvLabouchere 1
          fi
        else 
          echo -e "${redColour}[!] Ha salido impar, ¡Has perdido!${endColour}"
          auxInvLabouchere 0
        fi
      # Que has elegido impar
      else 
        if [ $(($random_number % 2)) -eq 0 ]; then
          echo -e "${redColour}[!] Ha salido par, ¡Has perdido!${endColour}"
          auxInvLabouchere 0
        else 
          echo -e "${greenColour}[+] Ha salido impar, ¡Has ganado!${endColour}"
          auxInvLabouchere 1
        fi
      fi
    else
      echo -e "\n\n${redColour}[!] Te has quedado sin dinero${endColour}"
      echo -e "${yellowColour}[+]${endColour} Has jugado un total de ${purpleColour}$games_counter${endColour} partidas"
      echo -e "${yellowColour}[+]${endColour} La máxima ganancia ha sido ${greenColour}$max_money${endColour}€"
      exit 0
    fi
    #sleep 0.5

    ((games_counter++))
  done

}

# Parametros que le pasamos cuando ejecutamos este script, los que llevan punto delante son los que les pasamos parametros(1 o más)
while getopts "m:t:h" arg; do
  case $arg in
    m) money=$OPTARG;;
    t) tecnica=$OPTARG;;
    h) helpPanel;;
  esac
done

if [ $money ] && [ $tecnica ]; then
  if [ "$tecnica" == "martingala" ]; then
    martingala
  elif [ "$tecnica" == "inverseLabouchere" ]; then
    inverseLabouchere
  else
    echo -e "\n${redColour}[!] La ténica introducida no existe${endColour}"
    helpPanel
  fi
else
  helpPanel
fi











