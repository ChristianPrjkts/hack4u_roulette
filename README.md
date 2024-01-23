This is a program that emulates some roulette techniques to win in even/odd game. Like: Martingala, inverse Labrouchere...

Some changes have been done from original code (hack4u academy)
flags to make desitions in conditionals

  declare -i match=0 # count number of matches
  declare -i player=0 # flag: player plays
  declare -i luck=0

In while bucle some chages were made
the logic for confitional was changed

  while true; do
    # verifying money
    if [ $money -gt $bet ];then
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


to duplicate bet an instruction were used like:  
    ((money += bet))

for bad_matches an array wars created
    bad_matches=() This is an empty array
to add values 
bad_matches+=($new_value)


