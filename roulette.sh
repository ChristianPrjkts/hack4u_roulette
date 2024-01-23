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

function ctrl_c ()
{
  echo -e "\n${redColour}[!] Aborting...${endColour}\n"
  tput cnorm; exit 1
}

# CTRL+C
trap ctrl_c INT

# Functions
function helpPanel ()
{
  echo -e "\t${purpleColour}[H]${endColour} ${grayColour}Use this progam as follows: ${endColour}\n"
  echo -e "\t${purpleColour}[+]${endColour} ${grayColour}Martingala: -m [money-amount] -t martingala ${endColour}\n"
  echo -e "\t${purpleColour}[+]${endColour} ${grayColour}Inverse Labrouchere: -m [money-amount] -t inverseLabrouchere ${endColour}\n"

  exit 1
}

# Martingala
function martingala ()
{
  
}

# Catching data
while getopts "m:t:h" param; do
  case $param in
    m) money="$OPTARG";;
    t) technique="$OPTARG";;
    h) helpPanel;;
  esac
done

if [ $money ] && [ $technique ]; then
  if [ $technique == "martingala" ]; then
    echo -e "Martingala\n"
  elif [ $technique == "inverseLabrouchere" ]; then
    echo -e "Inverse Labrouchere\n"
  else
     helpPanel
  fi
  else
    helpPanel
fi
