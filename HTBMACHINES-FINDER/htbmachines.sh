#!/bin/bash

#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

function ctrl_c(){
  echo -e "\n\n${redColour}[!] Sortint...${endColour}\n"
  tput cnorm && exit 1
}

#ctrl_c

trap ctrl_c INT

#Variables varies

main_url="https://htbmachines.github.io/bundle.js"

  function searchMachine(){
    tput civis
    machineName="$1"
    machineCheck="$(cat bundle.js | grep "name: \"$machineName\"" -i -A 9 | grep -vE  "id:|sku:|resuelta:" | tr -d '"",' | sed "s/^ * //")"  
    if [ "$machineCheck" ]; then
      sleep 1
      echo -e "\n${yellowColour}[+]${endColour} Llistant les propietats de la maquina ${greenColour}$machineName${endColour}:\n"
      sleep 1  
      echo -e "$machineCheck"
    else
      sleep 1 
      echo -e "\n${redColour}[!]${endColour} No existeix la maquina especificada ${greenColour}$machineName${endColour} en la base de dades"
    fi 
    tput cnorm
  }

  function updateFiles() {
    tput civis
    sleep 0.5
    echo -e "\n${yellowColour}[+]${endColour} Comprovant arxius..."
    sleep 0.5
    if [ ! -f bundle.js ]; then
      echo -e "\n${yellowColour}[+]${endColour} Descarregant arxius neccesaris..."
      curl -s $main_url > bundle.js
      js-beautify bundle.js | sponge bundle.js
      sleep 0.5
      echo -e "\n${yellowColour}[+]${endColour} Tots els arxius han sigut descarregars correctament"  
    else 
      sleep 0.5
      echo -e "\n${yellowColour}[+]${endColour} Comprovant si hi han actualitzacions pendents..."
      curl -s $main_url > bundle_temp.js  
      js-beautify bundle_temp.js | sponge bundle_temp.js
      md5_o_value=$(md5sum bundle.js | awk '{print $1}')
      md5_t_value=$(md5sum bundle_temp.js | awk '{print $1}')
        if [ "$md5_o_value" == "$md5_t_value" ]; then
          sleep 0.5
          echo -e "\n${yellowColour}[+]${endColour} Tens els arxius més actualitzats del moment"
          rm bundle_temp.js
        else
          sleep 0.5
          echo -e "\n${yellowColour}[+]${endColour} Actualitzant arxius neccesaris..."
          rm bundle.js && mv bundle_temp.js bundle.js
          sleep 0.5
          echo -e "\n${yellowColour}[+]${endColour} Tots els arxius han sigut actualitzats correctament"
        fi
    fi
    tput cnorm
  }

  function searchIp() {
    tput civis
    ipAdress="$1"
    machineName="$(cat bundle.js | grep "ip: \"$ipAdress\"" -B 3 | grep "name:" | tr -d '"",' | awk 'NF{print $NF}')"
      if [ "$machineName" ];then
        sleep 1 
        echo -e "\n${yellowColour}[+]${endColour} La maquina corresponent de la ip ${blueColour}$ipAdress${endColour} es ${greenColour}$machineName${endColour}"
        sleep 1
      echo -e "\n${yellowColour}[+]${endColour} Llistant les propietats de la maquina ${greenColour}$machineName${endColour}:\n"
      sleep 1
      cat bundle.js | grep "name: \"$machineName\"" -i -A 9 | grep -vE "id:|sku:|resuelta:" | tr -d '"",' | sed 's/^ *//'
    else
      sleep 1
      echo -e "\n${redColour}[!]${endColour} La IP especificada ${blueColour}$ipAdress${endColour} no correspon a ninguna maquina existent"
    fi
    tput cnorm
  }

  function searchLink(){
    tput civis
    machineName="$1"
    youtubeLink="$(cat bundle.js | grep "name: \"$machineName\"" -i -A 9 | grep -vE "id:|sku:|resuelta:" | tr -d '"",' | sed 's/^ *//' | grep youtube | awk 'NF{print $NF}')"
      if [ $youtubeLink ]; then
      sleep 1
      echo -e "\n${yellowColour}[+]${endColour} El link de resolució de la maquina ${greenColour}$machineName${endColour} es ${blueColour}$youtubeLink${endColour}"
    else
      sleep 1
      echo -e "\n${redColour}[!]${endColour} La maquina proporcionada ${greenColour}$machineName${endColour} no existeix"
    fi
    tput cnorm  
  }

  function filterDif(){
    tput civis
    difLevel="$1"
    machineLevel="$(cat bundle.js | grep "dificultad: \"$difLevel\"" -i -B 5 | grep "name:" | tr -d '"",' | awk 'NF{print $NF}' | column)"
      if [ "$machineLevel" ]; then
        sleep 1
        echo -e "\n${yellowColour}[+]${endColour} Les maquines amb el nivell de dificultat ${purpleColour}$difLevel${endColour} són les seguents:\n"
        sleep 1
        echo -e "${greenColour}$machineLevel${endColour}"
      else
        sleep 1
        echo -e "\n${redColour}[!]${endColour} El nivell de dificultat ${purpleColour}${difLevel}${endColour} no es existeix"
      fi
      tput cnorm
  }

  function getOS(){
    tput civis
    osRunning="$1"
    machineOS="$(cat bundle.js | grep "so: \"$osRunning\"" -i -B 5 | grep "name:" | tr -d '"",' | awk 'NF{print $NF}' | column)"
        if [ "$machineOS" ]; then
          sleep 1 
          echo -e "\n${yellowColour}[+]${endColour} Llistant les maquines amb el sistema operatiu ${blueColour}$osRunning${endColour}:\n"
          sleep 1 
          echo -e "${greenColour}$machineOS${endColour}"
        else
          sleep 1 
          echo -e "\n${redColour}[!]${endColour} El sistema operatiu ${blueColour}$osRunning${endColour} no pertany a ninguna maquina o no existeix"
        fi
        tput cnorm
  }

  function searchSkills(){
      tput civis
      skills="$1"
      checkSkills="$(cat bundle.js | grep "skills:" -B 6 | grep "$skills" -i -B 6 | grep "name:" | tr -d '"",' | awk 'NF{print $NF}' | column)"
        if [ "$checkSkills" ]; then
          sleep 1
          echo -e "\n${yellowColour}[+]${endColour} Llistant les maquines amb la skill ${yellowColour}$skills${endColour}:\n"
          sleep 1 
          echo -e "${greenColour}$checkSkills${endColour}"
        else
          sleep 1
          echo -e "\n${redColour}[!]${endColour} La skill indicada ${yellowColour}$skills${endColour} no existeix o no pertany a cap maquina"
        fi 
        tput cnorm
  }

  function searchCerts(){
    tput civis
    certs="$1"
    checkCerts="$(cat bundle.js | grep "like:" -B 7 | grep "$certs" -i -B 7 | grep "name:" | tr -d '"",' | awk 'NF{print $NF}' | column)"
        if [ "$checkCerts" ]; then
          sleep 1 
          echo -e "\n${yellowColour}[+]${endColour} Llistant totes les maquines amb els certificat ${greenColour}$certs${endColour}:\n"
          sleep 1 
          echo -e "${greenColour}$checkCerts${endColour}"
        else
          echo -e "\n${redColour}[!]${endColour} El certificat indicat ${greenColour}$certs${endColour} no existeix o no correspon a cap maquina"
        fi 
        tput cnorm
  }

  function getLOInfo(){
    tput civis
    difLevel="$1"
    osRunning="$2"
    check_LO_results="$(cat bundle.js | grep "so: \"$osRunning\"" -i -C 4 | grep "dificultad: \"$difLevel\"" -i -B 7 | grep "name:" | tr -d '"",' | awk 'NF{print $NF}' | column)"
      if [ "$check_LO_results" ]; then
        sleep 1 
        echo -e "\n${yellowColour}[+]${endColour} Llistant les maquines amb sistema operatiu ${blueColour}$osRunning${endColour} i dificultat ${purpleColour}$difLevel${endColour}:\n"
        sleep 1 
        echo -e "${greenColour}$check_LO_results${endColour}"
      else 
        sleep 1 
        echo -e "\n${redColour}[!]${endColour} Les maquines amb aquestes especificacions no existeixen o el sistema operatiu ${blueColour}$osRunning${endColour} o la dificultat ${purpleColour}$difLevel${endColour} especificats no son correctes"
      fi
      tput cnorm
  }

  function getCSInfo(){
    tput civis
    certs="$1"
    skills="$2"
    check_CS_results="$(cat bundle.js | grep "like:" -B 7 | grep "$certs" -i -B 7 | grep "skills:" -B 6 | grep "$skills" -i -B 6 | grep "name:" | tr -d '"",' | awk 'NF{print $NF}' | column)"
      if [ "$check_CS_results" ]; then
        sleep 1 
        echo -e "\n${yellowColour}[+]${endColour} Llistant les maquines amb certificat ${greenColour}$certs${endColour} i skill ${yellowColour}$skills${endColour}:\n"
        sleep 1 
        echo -e "${greenColour}$check_CS_results${endColour}"
      else 
        sleep 1 
        echo -e "\n${redColour}[!]${endColour} Les maquines amb aquestes especificacions no existeixen o el certificat ${greenColour}$certs${endColour} o la skill ${yellowColour}$skills${endColour} especificats no son correctes"
      fi
      tput cnorm
  }

  function getSLInfo(){
    tput civis
    skills="$1"
    difLevel="$2"
    check_SD_results="$(cat bundle.js | grep "skills:" -B 6 | grep "$skills" -i -B 6 | grep "dificultad:" -B 5 | grep "$difLevel" -i -B 5 | grep "name:" | tr -d '"",' | awk 'NF{print $NF}' | column)"
      if [ "$check_SD_results" ]; then
        sleep 1 
        echo -e "\n${yellowColour}[+]${endColour} Llistant les maquines amb skill ${yellowColour}$skills${endColour} i dificultat ${purpleColour}$difLevel${endColour}:\n"
        sleep 1 
        echo -e "${greenColour}$check_SD_results${endColour}"
      else 
        sleep 1 
        echo -e "\n${redColour}[!]${endColour} Les maquines amb aquestes especificacions no existeixen o la skill ${yellowColour}$certs${endColour} o la dificultat ${purpleColour}$difLevel${endColour} especificats no son correctes"
      fi
      tput cnorm
  }

  function getCLInfo(){
    tput civis
    certs="$1"
    difLevel="$2"
    check_CL_results="$(cat bundle.js | grep "like:" -B 7 | grep "$certs" -i -B 7 | grep "dificultad:" -i -B 5 | grep "$difLevel" -i -B 5 | grep "name:" | tr -d '"",' | awk 'NF{print $NF}' | column)"
      if [ "$check_CL_results" ]; then
        sleep 1 
        echo -e "\n${yellowColour}[+]${endColour} Llistant les maquines amb certificat ${greenColour}$certs${endColour} i dificultat ${purpleColour}$difLevel${endColour}:\n"
        sleep 1 
        echo -e "${greenColour}$check_CL_results${endColour}"
      else 
        sleep 1 
        echo -e "\n${redColour}[!]${endColour} Les maquines amb aquestes especificacions no existeixen o el certificat ${greenColour}$certs${endColour} o la dificultat ${purpleColour}$difLevel${endColour} especificats no son correctes"
      fi
      tput cnorm
  }

  function getSOInfo(){
    tput civis
    skills="$1"
    osRunning="$2"
    check_CS_results="$(cat bundle.js | grep "skills:" -B 6 | grep "$skills" -i -B 6 | grep "so:" -B 4 | grep "$osRunning" -i -B 4 | grep "name:" | tr -d '"",' | awk 'NF{print $NF}' | column)"
      if [ "$check_CS_results" ]; then
        sleep 1 
        echo -e "\n${yellowColour}[+]${endColour} Llistant les maquines amb skill ${yellowColour}$skills${endColour} i sistema operatiu ${blueColour}$osRunning${endColour}:\n"
        sleep 1 
        echo -e "${greenColour}$check_CS_results${endColour}"
      else 
        sleep 1 
        echo -e "\n${redColour}[!]${endColour} Les maquines amb aquestes especificacions no existeixen o la skill ${yellowColour}$skills${endColour} o  el sistema operatiu ${blueColour}$osRunning${endColour} especificats no son correctes"
      fi
      tput cnorm
  }

  function getCOInfo(){
    tput civis
    certs="$1"
    osRunning="$2"
    check_CO_results="$(cat bundle.js | grep "like:" -B 7 | grep "$certs" -i -B 7 | grep "so:" -B 4 | grep "$osRunning" -i -B 4 | grep "name:" | tr -d '"",' | awk 'NF{print $NF}' | column)"
      if [ "$check_CO_results" ]; then
        sleep 1 
        echo -e "\n${yellowColour}[+]${endColour} Llistant les maquines amb certificat ${greenColour}$certs${endColour} i sistema operatiu ${blueColour}$osRunning${endColour}:\n"
        sleep 1 
        echo -e "${greenColour}$check_CO_results${endColour}"
      else 
        sleep 1 
        echo -e "\n${redColour}[!]${endColour} Les maquines amb aquestes especificacions no existeixen o el certificat ${greenColour}$certs${endColour} o el sistema operatiu ${blueColour}$osRunning${endColour} especificats no son correctes"
      fi
      tput cnorm

  }

  function getLOSInfo(){
    tput civis
    difLevel="$1"
    osRunning="$2"
    skills="$3"
    check_LOS_results="$(cat bundle.js | grep "so: \"$osRunning\"" -i -C 4 | grep "dificultad: \"$difLevel\"" -i -C 5 | grep "skills:" -B 6 | grep "$skills" -i -B 6 | grep "name:" | tr -d '"",' | awk 'NF{print $NF}' | column)"
      if [ "$check_LOS_results" ]; then
        sleep 1 
        echo -e "\n${yellowColour}[+]${endColour} Llistant les maquines amb sistema operatiu ${blueColour}$osRunning${endColour}, dificultat ${purpleColour}$difLevel${endColour} i skill ${yellowColour}$skills${endColour}:\n"
        sleep 1
        echo -e "${greenColour}$check_LOS_results${endColour}"
      else 
        sleep 1 
        echo -e "\n${redColour}[!]${endColour} Les maquines amb aquestes especificacions no existeixen o el sistema operatiu ${blueColour}$osRunning${endColour}, la dificultat ${purpleColour}$difLevel${endColour} o la skill ${yellowColour}$skills${endColour} especificats no son correctes"
      fi
      tput cnorm
  }

  function getCSOInfo(){
    tput civis
    certs="$1"
    skills="$2"
    osRunning="$3"
    check_CSO_results="$(cat bundle.js | grep "like:" -B 7 | grep "$certs" -i -B 7 | grep "skills:" -B 6 | grep "$skills" -i -B 6 | grep "so:" -B 4 | grep "$osRunning" -i -B 4 | grep "name:" | tr -d '"",' | awk 'NF{print $NF}' | column)"
      if [ "$check_CSO_results" ]; then
        sleep 1 
        echo -e "\n${yellowColour}[+]${endColour} Llistant les maquines amb certificat ${greenColour}$certs${endColour}, skill ${yellowColour}$skills${endColour} i sistema operatiu ${blueColour}$osRunning${endColour}:\n"
        sleep 1
        echo -e "${greenColour}$check_CSO_results${endColour}"
      else 
        sleep 1 
        echo -e "\n${redColour}[!]${endColour} Les maquines amb aquestes especificacions no existeixen o el certificat ${greenColour}$certs${endColour}, la skill ${yellowColourColour}$skills${endColour} o el sistema operatiu ${blueColour}$skills${endColour} especificats no son correctes"
      fi
      tput cnorm
  }


  function getLOCInfo(){
    tput civis
    difLevel="$1"
    osRunning="$2"
    certs="$3"
    check_LOC_results="$( cat bundle.js | grep "so: \"$osRunning\"" -i -C 4 | grep "dificultad: \"$difLevel\"" -i -C 5 | grep "like:" -B 7 | grep "$certs" -i -B 7 | grep "name:" | tr -d '"",' | awk 'NF{print $NF}' | column)"
      if [ "$check_LOC_results" ]; then
        sleep 1 
        echo -e "\n${yellowColour}[+]${endColour} Llistant les maquines amb sistema operatiu ${blueColour}$osRunning${endColour}, dificultat ${purpleColour}$difLevel${endColour} i certificat ${yellowColour}$certs${endColour}:\n"
        sleep 1
        echo -e "${greenColour}$check_LOC_results${endColour}"
      else 
        sleep 1 
        echo -e "\n${redColour}[!]${endColour} Les maquines amb aquestes especificacions no existeixen o el sistema operatiu ${blueColour}$osRunning${endColour}, la dificultat ${purpleColour}$difLevel${endColour} o el certificat ${yellowColour}$certs${endColour} especificats no son correctes"
      fi
      tput cnorm
  }

  function getCSLInfo(){
    tput civis
    certs="$1"
    skills="$2"
    difLevel="$3"
    check_CSL_results="$(cat bundle.js | grep "like:" -B 7 | grep "$certs" -i -B 7 | grep "skills:" -B 6 | grep "$skills" -i -B 6 | grep "dificultad:" -B 5 | grep "$difLevel" -i -B 5 | grep "name:" | tr -d '"",' | awk 'NF{print $NF}' | column)"
      if [ "$check_CSL_results" ]; then
        sleep 1 
        echo -e "\n${yellowColour}[+]${endColour} Llistant les maquines amb certificat ${greenColour}$certs${endColour}, skill ${yellowColour}$skills${endColour} i dificultat ${purpleColour}$difLevel${endColour}:\n"
        sleep 1
        echo -e "${greenColour}$check_CSL_results${endColour}"
      else 
        sleep 1 
        echo -e "\n${redColour}[!]${endColour} Les maquines amb aquestes especificacions no existeixen o el certificat ${greenColour}$certs${endColour}, la skill ${yellowColourColour}$skills${endColour} o la dificultat ${purpleColour}$skills${endColour} especificats no son correctes"
      fi
      tput cnorm
  }


  function getLOSCInfo(){
    tput civis
    difLevel="$1"
    osRunning="$2"
    skills="$3"
    certs="$4"
    check_LOSC_results="$(cat bundle.js | grep "so: \"$osRunning\"" -i -C 4 | grep "dificultad: \"$difLevel\"" -i -C 5 | grep "skills:" -B 6 -A 1 | grep "$skills" -i -B 6 -A 1 | grep "like:" -B 7 | grep "$certs" -i -B 7 | grep "name:" | tr -d '"",' | awk 'NF{print $NF}' | column)"
      if [ "$check_LOSC_results" ]; then
        sleep 1 
        echo -e "\n${yellowColour}[+]${endColour} Llistant les maquines amb sistema operatiu ${blueColour}$osRunning${endColour}, dificultat ${purpleColour}$difLevel${endColour}, skills ${yellowColour}$skills${endColour} i certificats ${greenColour}$certs${endColour}:\n"
        sleep 1
        echo -e "${greenColour}$check_LOSC_results${endColour}"
      else 
        sleep 1 
        echo -e "\n${redColour}[!]${endColour} Les maquines amb aquestes especificacions no existeixen o el sistema operatiu ${blueColour}$osRunning${endColour}, la dificultat ${purpleColour}$difLevel${endColour}, la skill ${yellowColour}$skills${endColour} o el certificat ${greenColour}$certs${endColour} especificats no son correctes"
      fi
      tput cnorm
  }

  function helpPanel(){
    echo -e "\n${yellowColour}[+]${endColour}Usage: ./htbmachines.sh [options]"
    echo -e "\n\t${yellowColour}-m, --machine${endColour}\t\tBuscar per nom de la maquina"
    echo -e "\t${yellowColour}-u, --update${endColour}\t\tDescarregar o actualitzar arxius neccesaris"
    echo -e "\t${yellowColour}-i, --ip${endColour}\t\tBuscar per direcció ip de la maquina"
    echo -e "\t${yellowColour}-y, --youtube${endColour}\t\tObtenir link de la resolució de la maquina"
    echo -e "\t${yellowColour}-d, --difficulty${endColour}\tBuscar per nivell de dificultat (Insane,Difícil,Fácil,Media)"
    echo -e "\t${yellowColour}-o, --operatingsystem${endColour}\tBuscar per el sistema operatiu de la maquina (Windows,Linux)"
    echo -e "\t${yellowColour}-s  --skills${endColour}\t\tBuscar per nivell tecniques implementades en la maquina"
    echo -e "\t${yellowColour}-c, --certificates${endColour}\tBuscar per quins certificats val la maquina"
    echo -e "\t${yellowColour}-h, --help${endColour}\t\tMostrar panel d'ajuda"  
  }

  #Indicadors

  declare -i parameter_count=0

  #Txivatos

  declare -i txivato_difLevel=0
  declare -i txivato_osRunning=0
  declare -i txivato_skills=0
  declare -i txivato_certs=0 

  while getopts "m:ui:y:d:o:s:c:h" arg; do 
    case $arg in 
    m)machineName="$OPTARG"; let parameter_count+=1;; 
    u)let parameter_count+=2;;
    i)ipAdress="$OPTARG"; let parameter_count+=3;;
    y)machineName="$OPTARG"; let parameter_count+=4;;
    d)difLevel="$OPTARG"; let txivato_difLevel=1 let parameter_count+=5;;
    o)osRunning="$OPTARG"; let txivato_osRunning=1 let parameter_count+=6;;
    s)skills="$OPTARG"; let txivato_skills=1 let parameter_count+=7;;
    c)certs="$OPTARG"; let txivato_certs=1 let parameter_count+=8;;
    h);;
    esac

  done

  if [ $parameter_count -eq 1 ]; then
    searchMachine $machineName
  elif [ $parameter_count -eq 2 ]; then
    updateFiles
  elif [ $parameter_count -eq 3 ]; then
    searchIp $ipAdress
  elif [ $parameter_count -eq 4 ]; then
    searchLink $machineName
  elif [ $parameter_count -eq 5 ]; then
    filterDif $difLevel
  elif [ $parameter_count -eq 6 ]; then
    getOS $osRunning
  elif [ $parameter_count -eq 7 ]; then
    searchSkills "$skills"
  elif [ $parameter_count -eq 8 ]; then 
    searchCerts "$certs"
  elif [ $txivato_difLevel -eq 1 ] && [ $txivato_osRunning -eq 1 ] && [ $txivato_skills -eq 1 ] && [ $txivato_certs -eq 1 ]; then
    getLOSCInfo $difLevel $osRunning "$skills" $certs
  elif [ $txivato_difLevel -eq 1 ] && [ $txivato_osRunning -eq 1 ] && [ $txivato_skills -eq 1 ]; then
    getLOSInfo $difLevel $osRunning "$skills"
  elif [ $txivato_difLevel -eq 1 ] && [ $txivato_osRunning -eq 1 ] && [ $txivato_certs -eq 1 ]; then
    getLOCInfo $difLevel $osRunning $certs
  elif [ $txivato_certs -eq 1 ] && [ $txivato_skills -eq 1 ] && [ $txivato_osRunning -eq 1 ]; then 
    getCSOInfo $certs "$skills" $osRunning
  elif [ $txivato_certs -eq 1 ] && [ $txivato_skills -eq 1 ] && [ $txivato_difLevel -eq 1 ]; then 
    getCSLInfo $certs "$skills" $difLevel
  elif [ $txivato_difLevel -eq 1 ] && [ $txivato_osRunning -eq 1 ]; then 
    getLOInfo $difLevel $osRunning
  elif [ $txivato_certs -eq 1 ] && [ $txivato_skills -eq 1 ]; then 
    getCSInfo $certs "$skills"
  elif [ $txivato_skills -eq 1 ] && [ $txivato_difLevel -eq 1 ]; then 
    getSLInfo "$skills" $difLevel
  elif [ $txivato_skills -eq 1 ] && [ $txivato_osRunning -eq 1 ]; then 
    getSOInfo "$skills" $osRunning
  elif [ $txivato_certs -eq 1 ] && [ $txivato_difLevel -eq 1 ]; then 
    getCLInfo $certs $difLevel
  elif [ $txivato_certs -eq 1 ] && [ $txivato_osRunning -eq 1 ]; then 
    getCOInfo $certs $osRunning
  else
    helpPanel
  fi 
