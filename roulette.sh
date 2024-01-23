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
  echo -e "\n${purpleColour}[X]${endColour} ${yellowColour}Make sure that your enter an amount of money greater than zero and technique martingla/inverseLabrouchere!${endColour}\n"
  exit 1
}

# Martingala
function martingala ()
{
  money="$1"
  echo -e "\n${grayColour}[$] Your amount of money is${endColour} ${yellowColour}\$$money${endColour}\n"
  echo -ne "\n[>$] Enter your bet: " && read initial_bet
  echo -ne "\n[~]Enter if yo go for even/odd: " && read even_odd

  echo -e "\n${greenColour}[+]${endColour} ${grayColour}Playing with initial bet of${endColour} ${yellowColour}\$$initial_bet${endColour} ${blueColour}for $even_odd${endColour}\n"
  
  bet=$initial_bet # bet as initial_bet to start the game
  declare -i match=0 # count number of matches
  declare -i player=0 # flag: player plays
  output="" # roulette output even/odd

  while true; do
    # verifying money
    if [ $money -gt $bet ];then
      # count game
      let match+=1
      # generate random number 0-36
      random_number="$(($RANDOM%37))"
      echo -e "$random_number"
      
      if [ $random_number -eq 0 ];then  
        echo -e "perdemos\n"
        player=1; # house game, players lose
      elif [ $(($random_number%2)) -eq 0 ]; then
        echo -e "par\n"
        output="even"
        player=0 # player is playing
      else
        echo -e "impar\n"
        output="odd"
        player=0 # player is playing
      fi

      if [ $output == $even_odd ] && [ $player -eq 0 ]; then
        echo -e "ganamos"
        bet=$initial_bet # if player wins bet should be as initial_bet
        echo -e "\nbet $bet"

      elif [ $output != $even_odd ] && [ $player -eq 0 ]; then
        echo -e "pierdes"
        #bet=$(($bet*2))
        ((bet *= 2)) # player loses bet duplicates
        echo -e "\nbet $bet"

      else
        echo -e "gana la casa"
        ((bet *= 2)) # house wins, player loses bet duplicates
        echo -e "\nbet $bet"
      fi
      echo -e "\n partida $match"
    else # game over with summary
      echo -e "\nYou don't have enough money to bet!\n"
      exit 0
    fi

    sleep 1

  done

}

# Catching data
while getopts "m:t:h" param; do
  case $param in
    m) money="$OPTARG";;
    t) technique="$OPTARG";;
    h) helpPanel;;
  esac
done

if [ $money -gt 0 ] && [ $technique ]; then
  if [ $technique == "martingala" ]; then
    echo -e "Martingala\n"
    martingala $money
  elif [ $technique == "inverseLabrouchere" ]; then
    echo -e "Inverse Labrouchere\n"
  else
     helpPanel
  fi
  else
    helpPanel
fi
