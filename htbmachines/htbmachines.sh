#!/bin/bash

# ------------------------------
# VARIABLES GLOBALES
# ------------------------------
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

main_url="https://htbmachines.github.io/bundle.js"

# ------------------------------
# FUNCIONES DE CONTROL
# ------------------------------

# Gestor de Interrupciones con Ctrl+C
function ctrl_c(){
  echo -e "\n\n${redColour}[!] Saliendo...${endColour}"
  tput cnorm && exit 1
}

# Captar Ctrl+C --> Ejecutar la funcion ctrl_c
trap ctrl_c INT


# ------------------------------
# FUNCIONES DE LOGICA
# ------------------------------

# Panel de ayuda: Muestra instrucciones para el uso del script
function helpPanel() {
  echo -e "\n${yellowColour}[+]${endCOlour}${grayColour} Uso:${endColour}"
  echo -e "\t${purpleColour}u)${endColour}${grayCOlour} Descargar o actualizar archivos necesarios${endColour}"
  echo -e "\t${purpleColour}m)${endColour}${grayCOlour} Buscar por nombre de maquina${endColour}"
  echo -e "\t${purpleColour}i)${endColour}${grayCOlour} Buscar por la direccion IP${endColour}"
  echo -e "\t${purpleColour}y)${endColour}${grayCOlour} Obtener el link de la resolucion de la maquina en Youtube${endColour}"
  echo -e "\t${purpleColour}d)${endColour}${grayCOlour} Listar las maquinas por su dificultad${endColour}"
  echo -e "\t${purpleColour}o)${endColour}${grayCOlour} Listar las maquinas por su sistema operativo${endColour}"
  echo -e "\t${purpleColour}s)${endColour}${grayCOlour} Listar las maquinas por skill empleada${endColour}"
  echo -e "\t${purpleColour}h)${endColour}${grayCOlour} Mostrar este panel de ayuda${endColour}"
}

# Descarga de archivos: Descarga, verifica y realiza actualizaciones a archivos necesarios
function updateFiles(){
  if [ ! -f bundle.js ]
  then
    tput civis
    echo -e "\n${yellowColour}[+]${endColour}${grayColour} Descargando archivos necesarios...${endColour}"

    curl -s $main_url > bundle.js
    js-beautify bundle.js | sponge bundle.js

    echo -e "\n${yellowColour}[+]${endColour}${grayColour} Archivos descargados${endColour}"
    tput cnorm  
  else
    tput civis
    echo -e "\n${yellowColour}[+]${endColour}${grayColour} Comprobando si hay actualizaciones..."
    sleep 1

    curl -s $main_url > bundle_temp.js
    js-beautify bundle_temp.js | sponge bundle_temp.js

    md5sum_value_original=$(md5sum bundle.js | awk '{print $1}')
    md5sum_value_temp=$(md5sum bundle_temp.js | awk '{print $1}')

    if [ "$md5sum_value_temp" == "$md5sum_value_original" ]
    then
      echo -e "\n${yellowColour}[+]${endColour}${grayColour} No hay actualizaciones pendientes. Lo tienes todo al dia :)${endColour}"

      rm bundle_temp.js
    else
      echo -e "\n${yellowColour}[+]${endColour}${grayColour} Se han encontrado actualizaciones. Descargando...${endColour}"
      sleep 1

      rm bundle.js && mv bundle_temp.js bundle.js
      
      echo -e "\n${yellowColour}[+]${endColour}${grayColour} Los archivos han sido actualizados${endColour}"
    fi
    tput cnorm
  fi  
}

# Logica de busqueda: Lista propiedades de la maquina a partir del nombre proporcionado
function searchMachine() {
  machineName=$1

  machineName_cheaker="$(cat bundle.js | awk /"name: \"$machineName"\"/,/"resuelta:"/ | sed 's/^ *//' | grep -vE "id|sku|resuelta" | tr -d '"' | tr -d ',')"

  if [ "$machineName_cheaker" ]
  then
    echo -e "\n${yellowColour}[+]${endColour}${grayColour} Listando las propiedades de la maquina${endColour}${blueColour} $machineName${endColour}${grayColour}:${endColour}\n"

    cat bundle.js | awk /"name: \"$machineName"\"/,/"resuelta:"/ | sed 's/^ *//' | grep -vE "id|sku|resuelta" | tr -d '"' | tr -d ','
  else
    echo -e "\n${redColour}[!] La maquina proporcionada no existe${endColour}"
  fi 
}

# Logica de busqueda: Busca nombre de la maquina a partir de la direccion IP oporcionada
function searchIP(){
  IPaddress=$1

  machineName="$(cat bundle.js | grep "ip: \"$IPaddress\"" -B 3 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',')"

  if [ "$machineName" ]
  then
    echo -e "\n${yellowColour}[+]${endColour}${grayColour} La maquina correspondiente para la IP${endColour} ${purpleColour}$IPaddress${endColour}${grayColour} es${endColour} ${blueColour}$machineName${endColour}\n"
  else
    echo -e "\n${redColour}[!] La direccion IP proporcionada no existe${endColour}"
  fi 
}

# Logica de busqueda: Busca link de youtube a partir del nombre de la maquina proporcionado
function search_by_link(){
  machineName=$1

  link="$(cat bundle.js | awk /"name: \"$machineName"\"/,/"resuelta:"/ | sed 's/^ *//' | grep -vE "id|sku|resuelta" | tr -d '"' | tr -d ',' | grep youtube)"

  if [ "$link" ]
  then
    echo -e "${yellowColour}[+]${endColour}${grayColour} El link de la resolucion de la maquina${endColour}${blueColour} $machineName${endColour} ${grayColour}es${endCOlour} ${purpleColour}$link${endColour}"
  else
    echo -e "\n${redColour}[!] La maquina proporcionada no existe${endColour}"
  fi 
}

# Logica de busqueda: Busca nombre de maquinas a partir de la dificultad
function search_by_difficulty(){
  difficulty=$1

  machineNames="$(cat bundle.js | grep "dificultad: \"$difficulty\"" -B 5 | grep "name: " | awk 'NF{print $NF}' |tr -d '"' | tr -d ',' | column)"

  if [ "$machineNames" ] 
  then
    echo -e "\n${yellowColour}[+]${endColour}${grayColour} El nombre de las maquinas de dificultad${endColour}${turquoiseColour} $difficulty${endColour}${grayColour} son:${endColour}\n"
    cat bundle.js | grep "dificultad: \"$difficulty\"" -B 5 | grep "name: " | awk 'NF{print $NF}' |tr -d '"' | tr -d ',' | column
else 
    echo -e "\n${redColour}[!] La dificultad proporcionada no es correcta${endColour}"
  fi
}

# Logica de busqueda: Busca nombre de maquinas a partir del sistema operativo
function search_by_OS(){
  operativeSystem=$1

  machineNames="$(cat bundle.js | grep "so: \"$operativeSystem\"" -B 5 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column)"

  if [ "$machineNames" ]
  then
    echo -e "\n${yellowColour}[+]${endColour}${grayColour} El nombre de las maquinas de sistema operativo tipo${endColour}${turquoiseColour} $operativeSystem${endColour}${grayColour} son:${endColour}\n"
    cat bundle.js | grep "so: \"$operativeSystem\"" -B 5 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column
  else
    echo -e "\n${redColour}[!] El sistema operativo proporcionado no es correcta${endColour}"
  fi 
}

# Logica de busqueda: Busca nombre de maquinas a partir de la dificultad y del sistema operativo, ambos filtros
function search_by_OSdifficulty(){
  difficulty=$1
  operativeSystem=$2

  check_result="$(cat bundle.js | grep "so: \"$operativeSystem\"" -C 4 | grep "dificultad: \"$difficulty\"" -B 5 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column)"

  if [ "$check_result" ]
  then 
    echo -e "\n${yellowColour}[+]${endColour}${grayColour} El nombre de las maquinas de sistema operativo tipo${endColour}${turquoiseColour} $operativeSystem${endColour}${grayColour} y dificultad${endColour}${turquoiseColour} $difficulty${endColour}${grayColour} son:${endColour}\n"
  cat bundle.js | grep "so: \"$operativeSystem\"" -C 4 | grep "dificultad: \"$difficulty\"" -B 5 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column
  else
    echo -e "\n${redColour}[!] El sistema operativo o la dificultad proporcionado no es correcta${endColour}"
  fi
}

# Logica de busqueda: Busca nombre de maquinas a partir de la skill empleada
function search_by_skill(){
  skill=$1

  check_result="$(cat bundle.js | grep "skills: " -B 6| grep "$skill" -i -B 6 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column)"

  if [ "$check_result" ]
  then 
    echo -e "\n${yellowColour}[+]${endColour}${grayColour} El nombre de las maquinas segun la skill empleada${endColour}${turquoiseColour} $skill${endColour}${grayColour} son:${endColour}\n"
    cat bundle.js | grep "skills: " -B 6| grep "$skill" -i -B 6 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column
  else
    echo -e "\n${redColour}[!] La skill proporcionada no es correcta${endColour}"
  fi
}

# ------------------------------
# PROCESAMIENTO ARGUMENTOS (MAIN)
# ------------------------------

# Indicador
declare -i parameter_counter=0
declare -i flag_os=0
declare -i flag_difficulty=0

# Ciclo de lectura de opciones con getopts + logica de ejecucion con case
while getopts "m:i:y:d:o:s:uh" arg
do
  case $arg in
    m) machineName=$OPTARG; let parameter_counter+=1;;
    u) let parameter_counter+=2;;
    i) ipAddress=$OPTARG; let parameter_counter+=3;;
    y) machineName=$OPTARG; let parameter_counter+=4;;
    d) difficulty=$OPTARG; flag_difficulty=1; let parameter_counter+=5;;
    o) operativeSystem=$OPTARG; flag_os=1; let parameter_counter+=6;;
    s) skill=$OPTARG; let parameter_counter+=7;;
    h) ;;
  esac
done

# Flujo principal de ejecucion
if [ $parameter_counter -eq 1 ]
then
  searchMachine $machineName
elif [ $parameter_counter -eq 2 ]
then
  updateFiles
elif [ $parameter_counter -eq 3 ]
then
  searchIP $ipAddress
elif [ $parameter_counter -eq 4 ]
then
  search_by_link $machineName
elif [ $parameter_counter -eq 5 ]
then
  search_by_difficulty $difficulty
elif [ $parameter_counter -eq 6 ]
then
  search_by_OS $operativeSystem
elif [ $flag_difficulty -eq 1 ] && [ $flag_os -eq 1 ]
then
  search_by_OSdifficulty $difficulty $operativeSystem
elif [ $parameter_counter -eq 7 ]
then 
  search_by_skill "$skill"
else
  helpPanel
fi
