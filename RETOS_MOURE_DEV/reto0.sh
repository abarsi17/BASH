#! /bin/bash

### 
# Escribe un programa que muestre por consola (con un print) los
# números de 1 a 100 (ambos incluidos y con un salto de línea entre
# cada impresión), sustiuyendo los siguientes:
# - Múltiplos de 3 por la palabra "fizz"
# - Múltiplos de 5 por la palabra "buzz"
# - Múltiplos de 3 y de 5 por la palabra "fizzbuzz"
###


# PRIMERA FORMA: utilizando let 
echo -e "\nPRIMERA FORMA\n"

for n in $(seq 1 100); do
	# Se utiliza el let para 
	let varMod3=$n%3
	let varMod5=$n%5

	if [ $varMod3 -eq 0 ] && [ $varMod5 -eq 0 ]; then
		echo "fizzbuzz"
	elif [ $varMod3 -eq 0 ]; then
		echo "fizz"
	elif [ $varMod5 -eq 0 ]; then
		echo "buzz"
	else
		echo "$n"
	fi
done

# SEGUNDA FORMA
echo -e "\nSEGUNDA FORMA\n"

for ((n=1; n<=100; n++)) do
	if [ $(($n%3)) -eq 0 ] && [ $(($n%5)) -eq 0 ]; then
		echo "fizzbuzz"
	elif [ $(($n%3)) -eq 0 ]; then
		echo "fizz"
	elif [ $(($n%5)) -eq 0 ]; then
		echo "buzz"
	else
		echo "$n"
	fi
done
