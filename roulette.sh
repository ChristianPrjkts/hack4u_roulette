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
  echo -e "\t${purpleColour}[+]${endColour} ${grayColour}Inverse Labouchere: -m [money-amount] -t inverseLabouchere ${endColour}\n"
  echo -e "\n${purpleColour}[X]${endColour} ${yellowColour}Make sure that your enter an amount of money greater than zero and technique martingla/inverseLabouchere!${endColour}\n"
  exit 1
}

# Martingala
function martingala ()
{
  money="$1"
  echo -e "\n${grayColour}[$] Your amount of money is${endColour} ${yellowColour}\$$money${endColour} ${grayColour}you are playing${endColour} ${blueColour}Martingala${endColour} \n"
  echo -ne "\n[>$] Enter your bet: " && read initial_bet
  echo -ne "\n[~]Enter if you go for even/odd: " && read even_odd

  echo -e "\n${greenColour}[+]${endColour} ${grayColour}Playing with initial bet of${endColour} ${yellowColour}\$$initial_bet${endColour} ${blueColour}for $even_odd${endColour}\n"
  
  bet=$initial_bet # bet as initial_bet to start the game
  initial_money=$money
  declare -i match=0 # count number of matches
  declare -i player=0 # flag: player plays
  declare -i luck=0
  reward=0
  output="" # roulette output even/odd
  bad_matches=()

  while true; do
    # verifying money
    if [ $money -gt 0 ];then
      # count game
      let match+=1
      # generate random number 0-36
      random_number="$(($RANDOM%37))"
      # roulette output
      if [ $random_number -eq 0 ];then  
        player=1; # house game, players lose
      elif [ $(($random_number%2)) -eq 0 ]; then
        output="even"
        player=0 # player is playing
      else
        output="odd"
        player=0 # player is playing
      fi

      # martingala technique algorithm
      if [ $output == $even_odd ] && [ $player -eq 0 ]; then # you win
       # echo -e "\nyour money $money\n"
        reward=$((2 * bet))
      #  echo -e "\nYou win\n"
       # echo -e "Your bet was $bet\n"
      #  echo -e "your reward is $reward\n"
        ((money += reward))
      #  echo -e "your money now is: $money\n"
        bet=$initial_bet # if player wins bet should be as initial_bet
      #  echo -e "Your bet now is: $bet\n"
        ((money-=bet))
      #  echo -e "Your money is $money\n"
        luck=0

      elif [[ ($output != $even_odd && $player -eq 0) || $player -eq 1 ]]; then # you lose
      #  echo -e "\nYpur money is: $money\n"
      #  echo -e "perdiste con $random_number\n"
        ((money -= bet))
      #  echo -e "Your money now is $money\n"
        ((bet *= 2)) # player loses bet duplicates
        luck=1
      #  echo -e "your bet now is $bet\n"

      fi
      
      if [ $luck -eq 1 ]; then
        bad_matches+=($random_number)
      else
        bad_matches=()
      fi
    else # game over with summary

      if [ "$money" -lt 0 ]; then
        debt=$((money*(-1)))
        money=0
      else
        debt=0
      fi

      echo -e "\n${redColour}[!] You don't have enough money to bet!${endColour}\n"
      echo -e "\t${greenColour}[$]${endColour} ${grayColour}You started with${endColour} ${yellowColour}\$$initial_money${endColour} ${grayColour}and turned out with${endColour} ${yellowColour}\$$money${endColour} ${grayColour}and your debt is${endColour} ${redColour}\$$debt${endColour} \n"
      echo -e "\t${purpleColour}[x]${endColour} ${grayColour}You played${endColour} ${blueColour}$match${endColour} ${grayColour}matches${endColour}\n"
      echo -e "\t${purpleColour}[+]${endColour} ${grayColour}Your consecutive lost matches are:${endColour} ${turquoiseColour}[ ${bad_matches[@]} ] ${endColour}\n"

      exit 0
    fi
  done
}

# read to set sequence
function readArray ()
{
  declare -i array_size=0

  echo -ne "\nEnter the size of the array: " && read array_size

  for ((i=0; i<array_size; i++)); do
    echo -ne "Enter the element[$i]: " && read sequence[$i]
  done
 
}

# labouchere method
function inverseLabouchere ()
{
  money="$1"
  
  echo -e "\n${grayColour}[$] Your amount of money is${endColour} ${yellowColour}\$$money${endColour} ${grayColour}you are playing${endColour} ${blueColour}Inverse Labouchere${endColour} \n"
  #echo -ne "\n[>$] Enter your bet: " && read initial_bet
  echo -ne "\n[~] Enter if you go for even/odd: " && read even_odd

  echo -e "\n${greenColour}[+]${endColour} ${grayColour}Playing with initial bet of${endColour} ${yellowColour}\$$initial_bet${endColour} ${blueColour}for $even_odd${endColour}\n"
  initial_money=$money
  declare -a sequence=()
  readArray
  bet=$((${sequence[0]}+${sequence[-1]}))
  declare -i match=0
  declare -i player=0
  output=""

  while true; do
    if [ $money -gt $bet]; then
      let match+=1

      # generate random number 0-36
      random_number="$(($RANDOM%37))"
      # roulette output
      if [ $random_number -eq 0 ];then  
        player=1; # house game, players lose
      elif [ $(($random_number%2)) -eq 0 ]; then
        output="even"
        player=0 # player is playing
      else
        output="odd"
        player=0 # player is playing
      fi

      # martingala technique algorithm
      if [ $output == $even_odd ] && [ $player -eq 0 ]; then
        ((money += bet))
        ((bet=$initial_bet)) # if player wins bet should be as initial_bet
        luck=0

      elif [ $output != $even_odd ] && [ $player -eq 0 ] || [ $player -eq 1 ]; then
        ((money -= bet))
        ((bet *= 2)) # player loses bet duplicates
        luck=1

      fi
      
    else
      echo "You don't have enough money to bet!\n"
    fi
  done

  echo -e "la secuencia es: [ ${sequence[@]} ]"

  suma=$((${sequence[0]} + ${sequence[-1]}))

  echo -e "la suma es $suma"

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
    martingala $money

  elif [ $technique == "inverseLabouchere" ]; then
    inverseLabouchere $money
  else
     helpPanel
  fi
  else
    helpPanel
fi
