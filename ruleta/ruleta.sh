#!/bin/bash

# ------------------------------
# VARIABLES GLOBALES
# ------------------------------
# Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"


# ------------------------------
# FUNCIONES DE CONTROL
# ------------------------------

# Gestion de interrupciones con ctrl+c
function ctrl_c(){
  echo -e "\n\n${redColour}[!] Saliendo...${endColour}\n"
  tput cnorm && exit 1
}

trap ctrl_c INT


# ------------------------------
# FUNCIONES DE LOGICA
# ------------------------------

# Panel de ayuda para el usuario
function helpPanel(){
  echo -e "\n${yellowColour}[+]${endColour}${grayColour} Uso:${endColour}${purpleColour} $0${endColour} "
  echo -e "\t${purpleColour}m)${endColour}${grayColour} Dinero con el que se desea jugar${endCcolour}"
  echo -e "\t${purpleColour}h)${endColour}${grayColour} Tecnica a utilizar${endCcolour}${turquoiseColour} (martingala o inverseLabrouchere)${endColour}"
}


# Logica de la tecnica de juego Martingala
function martingala(){
  echo -e "\n${yellowColour}[+]${endColour}${grayColour} Dinero actual:${endColour}${greenColour} $money$ ${endColour}"
  echo -ne "${yellowColour}[+]${endColour}${grayColour} ¿Cuanto dinero tienes pensado aportar? -> ${endColour}" && read initial_bet
  echo -ne "${yellowColour}[+]${endColour}${grayColour} ¿A que deseas apostar continuamente?${endColour}${turquoiseColour} (par/impar)${endColour}${grayColour} -> ${endColour}" && read par_impar

#  echo -e "${blueColour}[+]${endColour}${grayColour} Vamos a jugar con una cantidad inicial de${endColour}${greenColour} $initial_bet$ ${endColour}${grayColour}a${endColour} ${greenColour}$par_impar${endColour}\n"

  backup_bet=$initial_bet
  plays_counter=0
  bad_plays=""
  money_compare=0
  
  tput civis
  while true
  do
    money=$(($money-$initial_bet))

#    echo -e "\n${blueColour}[+]${endColour}${grayColour} Acabas de apostar${endColour}${greenColour} $initial_bet$ ${grayColour}Ahora tienes${endColour}${greenColour} $money$ ${endColour}" 
    
    random_number=$((RANDOM % 37))

#    echo -e "${yellowColour}[+]${endColour}${grayColour} Ha salido el numero${endColour}${greenColour} $random_number${endColour}"

    if [ "$money" -ge 0 ]
    then
      # Logica para cuando se decida jugar par
      if [ "$par_impar" == "par" ]
      then
        if [ "$(($random_number % 2))" -eq 0 ] 
        then
          if [ "$random_number" -eq 0 ]
          then
#            echo -e "${yellowColour}[+]${endColour}${grayColour} El numero que ha salido es 0,${endColour}${redColour} ¡pierdes!${endColour}"

            initial_bet=$(($initial_bet*2))
            bad_plays+="$random_number "
          else
#            echo -e "${yellowColour}[+]${endColour}${grayColour} El numero que ha salido es par,${endColour}${greenColour} ¡ganas!${endColour}"

            reward=$(($initial_bet*2))
            money=$(($money+$reward))
            money_compare=$money
          
#            echo -e "${yellowColour}[+]${endColour}${grayColour} Has ganado${endColour} ${greenColour}$reward$ ${endColour} ${grayColour}Ahora tienes${endColour}${greenColour} $money$ ${endColour}"

            initial_bet=$backup_bet
            bad_plays=""
          fi
        else 
#          echo -e "${yellowColour}[+]${endColour}${grayColour} El numero que ha salido es impar,${endColour}${redColour} ¡pierdes!${endColour}"
        
        initial_bet=$(($initial_bet*2))
        bad_plays+="$random_number "
        fi

      # Logica para cuando se decida jugar impar 
      else 
        if [ "$(($random_number % 2))" -eq 0 ] 
        then
          if [ "$random_number" -eq 0 ]
          then
#            echo -e "${yellowColour}[+]${endColour}${grayColour} El numero que ha salido es 0,${endColour}${redColour} ¡pierdes!${endColour}"

            initial_bet=$(($initial_bet*2))
            bad_plays+="$random_number "
          else
#            echo -e "${yellowColour}[+]${endColour}${grayColour} El numero que ha salido es par,${endColour}${redColour} ¡pierdes!${endColour}"

            initial_bet=$(($initial_bet*2))
            bad_plays+="$random_number "
          fi
        else 
#          echo -e "${yellowColour}[+]${endColour}${grayColour} El numero que ha salido es impar,${endColour}${greenColour} ¡ganas!${endColour}"

          reward=$(($initial_bet*2))
          money=$(($money+$reward))
          money_compare=$money
        
#          echo -e "${yellowColour}[+]${endColour}${grayColour} Has ganado${endColour} ${greenColour}$reward$ ${endColour} ${grayColour}Ahora tienes${endColour}${greenColour} $money$ ${endColour}"

          initial_bet=$backup_bet
          bad_plays=""
        fi      
      fi  

    # Logica para cuando el dinero sea menor a 0  
    else
      echo -e "\n${redColour}[!] Te has quedado sin dinero${endColour}"
      echo -e "\n${yellowColour}[+]${endColour}${grayColour} Han ocurrido un total de${endColour}${blueColour} $plays_counter${endColour}${grayColour} jugadas${endColour}"
      echo -e "${yellowColour}[+]${endColour}${grayColour} A continuacion se mostraran las jugadas consecutivas malas:${endColour} ${blueColour}$bad_plays${endColour}"
      echo -e "${yellowColour}[+]${endColour}${grayColour} La cantidad maxima de dinero que alcanzaste fue:${endColour}${greenColour} $money_compare$ ${endColour}"
      tput cnorm && exit 0
    fi

    let plays_counter+=1
  done
  tput cnorm
}


# Logica de la tecnica de juego inverseLabrouchere
function inverseLabrouchere(){
  echo -e "\n${yellowColour}[+]${endColour}${grayColour} Dinero actual:${endColour}${greenColour} $money$ ${endColour}"
  echo -ne "${yellowColour}[+]${endColour}${grayColour} ¿A que deseas apostar continuamente?${endColour}${turquoiseColour} (par/impar)${endColour}${grayColour} -> ${endColour}" && read par_impar
 
  declare -a my_sequence=(1 2 3 4)
  plays_counter=0
  bet_to_renew=$(($money+50))

  echo -e "${yellowColour}[+]${endColour}${grayColour} Comenzamos con la secuencia${endColour} ${greenColour}[${my_sequence[@]}]${endColour}"

  bet=$((${my_sequence[0]} + ${my_sequence[-1]}))

  tput civis
  while true
  do 
    money=$(($money-$bet))
    
    echo -e "\n${redColour}[+]${endColour}${grayColour} Acabas de apostar${endColour}${greenColour} $bet$ ${grayColour}Ahora tienes${endColour}${greenColour} $money$ ${endColour}" 
 
    random_number=$((RANDOM % 37))
    
    echo -e "${yellowColour}[+]${endColour}${grayColour} Ha salido el numero${endColour}${greenColour} $random_number${endColour}"


    if [ "$money" -ge 0 ]
    then
      # Logica para cuando se decida jugar par
      if [ "$par_impar" == "par" ]
      then
        if [ "$(($random_number % 2))" -eq 0 ] 
        then
          if [ "$random_number" -eq 0 ]
          then
            echo -e "${yellowColour}[+]${endColour}${grayColour} El numero que ha salido es 0,${endColour}${redColour} ¡pierdes!${endColour}"
            
            unset my_sequence[0]
            unset my_sequence[-1] 2>/dev/null
            my_sequence=(${my_sequence[@]})

            echo -e "${yellowColour}[+]${endColour}${grayColour} Ahora la secuencia se actualiza ha${endColour}${greenColour} [${my_sequence[@]}]${endColour}"

            if [ "${#my_sequence[@]}" -gt 1 ]
            then
              bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
            elif [ "${#my_sequence[@]}" -eq 1 ]
            then
              bet=${my_sequence[0]}
            elif [ "${#my_sequence[@]}" -eq 0 ]
            then
              echo -e "${redColour}[!] La secuencia ha muerto${endColour}"
              my_sequence=(1 2 3 4)
              echo -e "${yellowColour}[+]${endColour}${grayColour} Restablecemos la secuencia a${endColour}${greenColour} [${my_sequence[@]}]${endColour}"
              bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
            fi 
            
          else
            echo -e "${yellowColour}[+]${endColour}${grayColour} El numero que ha salido es par,${endColour}${greenColour} ¡ganas!${endColour}"

            reward=$(($bet*2))
            money=$(($money+$reward))
        
            echo -e "\n${blueColour}[+]${endColour}${grayColour} Ganaste${endColour}${greenColour} $reward$ ${grayColour}Ahora tienes${endColour}${greenColour} $money$ ${endColour}" 
            
            if [ "$money" -gt "$bet_to_renew" ]
            then
              echo -e "[+] Has superado el tope establecido $bet_to_renew$"
              bet_to_renew=$(($bet_to_renew+50))
              echo -e "[+] El tope se ha actualizado ha $bet_to_renew$"
              my_sequence=(1 2 3 4)
              bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
              echo -e "[+] Ahora tu nueva secuencia es [${my_sequence[@]}]"
            else 
              my_sequence+=($bet)
              my_sequence=(${my_sequence[@]})

              echo -e "${yellowColour}[+]${endColour}${grayColour} La secuencia se actualiza, ahora es${endColour}${greenColour} [${my_sequence[@]}]${endColour}"
             
              bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
            fi 
          fi
        else
          echo -e "${yellowColour}[+]${endColour}${grayColour} El numero que ha salido es impar,${endColour}${redColour} ¡pierdes!${endColour}"

          unset my_sequence[0]
          unset my_sequence[-1] 2>/dev/null
          my_sequence=(${my_sequence[@]})

          echo -e "${yellowColour}[+]${endColour}${grayColour} Ahora la secuencia se actualiza ha${endColour}${greenColour} [${my_sequence[@]}]${endColour}"

          if [ "${#my_sequence[@]}" -gt 1 ]
          then
            bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
          elif [ "${#my_sequence[@]}" -eq 1 ]
          then
            bet=${my_sequence[0]}
          elif [ "${#my_sequence[@]}" -eq 0 ]
          then
            echo -e "${redColour}[!] La secuencia ha muerto${endColour}"
            my_sequence=(1 2 3 4)
            echo -e "${yellowColour}[+]${endColour}${grayColour} Restablecemos la secuencia a${endColour}${greenColour} [${my_sequence[@]}]${endColour}"
            bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
          fi  
        fi
      
      # Logica para cuando se decida jugar impar 
      else
        if [ "$(($random_number % 2))" -eq 0 ] 
        then
          if [ "$random_number" -eq 0 ]
          then
            echo -e "${yellowColour}[+]${endColour}${grayColour} El numero que ha salido es 0,${endColour}${redColour} ¡pierdes!${endColour}"
            
            unset my_sequence[0]
            unset my_sequence[-1] 2>/dev/null
            my_sequence=(${my_sequence[@]})

            echo -e "${yellowColour}[+]${endColour}${grayColour} Ahora la secuencia se actualiza ha${endColour}${greenColour} [${my_sequence[@]}]${endColour}"

            if [ "${#my_sequence[@]}" -gt 1 ]
            then
              bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
            elif [ "${#my_sequence[@]}" -eq 1 ]
            then
              bet=${my_sequence[0]}
            elif [ "${#my_sequence[@]}" -eq 0 ]
            then
              echo -e "${redColour}[!] La secuencia ha muerto${endColour}"
              my_sequence=(1 2 3 4)
              echo -e "${yellowColour}[+]${endColour}${grayColour} Restablecemos la secuencia a${endColour}${greenColour} [${my_sequence[@]}]${endColour}"
              bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
            fi 

          else
            echo -e "${yellowColour}[+]${endColour}${grayColour} El numero que ha salido es par,${endColour}${redColour} ¡pierdes!${endColour}"

            unset my_sequence[0]
            unset my_sequence[-1] 2>/dev/null
            my_sequence=(${my_sequence[@]})

            echo -e "${yellowColour}[+]${endColour}${grayColour} Ahora la secuencia se actualiza ha${endColour}${greenColour} [${my_sequence[@]}]${endColour}"

            if [ "${#my_sequence[@]}" -gt 1 ]
            then
              bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
            elif [ "${#my_sequence[@]}" -eq 1 ]
            then
              bet=${my_sequence[0]}
            elif [ "${#my_sequence[@]}" -eq 0 ]
            then
              echo -e "${redColour}[!] La secuencia ha muerto${endColour}"
              my_sequence=(1 2 3 4)
              echo -e "${yellowColour}[+]${endColour}${grayColour} Restablecemos la secuencia a${endColour}${greenColour} [${my_sequence[@]}]${endColour}"
              bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
            fi

          fi 
        else
          echo -e "${yellowColour}[+]${endColour}${grayColour} El numero que ha salido es impar,${endColour}${greenColour} ¡ganas!${endColour}"
          reward=$(($bet*2))
          money=$(($money+$reward))
        
          echo -e "\n${blueColour}[+]${endColour}${grayColour} Ganaste${endColour}${greenColour} $reward$ ${grayColour}Ahora tienes${endColour}${greenColour} $money$ ${endColour}" 

          if [ "$money" -gt "$bet_to_renew" ]
          then
            echo -e "[+] Has superado el tope establecido $bet_to_renew$"
            bet_to_renew=$(($bet_to_renew+50))
            echo -e "[+] El tope se ha actualizado ha $bet_to_renew$"
            my_sequence=(1 2 3 4)
            bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
            echo -e "[+] Ahora tu nueva secuencia es [${my_sequence[@]}]"
          else 
            my_sequence+=($bet)
            my_sequence=(${my_sequence[@]})

            echo -e "${yellowColour}[+]${endColour}${grayColour} La secuencia se actualiza, ahora es${endColour}${greenColour} [${my_sequence[@]}]${endColour}"
            bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
          fi  
        fi    
      fi  
    
    # Logica para cuando el dinero sea menor a 0
    else
      echo -e "\n${redColour}[!] Te has quedado sin dinero${endColour}"
      echo -e "\n${yellowColour}[+]${endColour}${grayColour} Han ocurrido un total de${endColour}${blueColour} $plays_counter${endColour}${grayColour} jugadas${endColour}"
      tput cnorm && exit 0
    fi 
  let plays_counter+=1
  done
  tput cnorm
}

# ------------------------------
# PROCESAMIENTO ARGUMENTOS (MAIN)
# ------------------------------

# Indicadores
declare -i parameter_counter=0


# Ciclo de lectura de opciones con getopts + logica de ejecucion con case
while getopts {m:t:h} arg
do
  case $arg in
    m) money=$OPTARG;;
    t) technique=$OPTARG;;
    h) ;;
  esac
done

# Flujo principal de ejecucion
if [ $money ] && [ $technique ]
then
  if [ "$technique" == "martingala" ]
  then
    martingala
  elif [ "$technique" == "inverseLabrouchere" ]
  then
    inverseLabrouchere
  else
    echo -e "\n${redColour}[!] La tecnica introducida no existe${endColour}"
    helpPanel
  fi
else
  helpPanel
fi


