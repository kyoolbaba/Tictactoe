#!/bin/bash

chooseXorO(){ 
#ASSIGNING X OR O FEATURE
    declare toss=("Heads" "Tails")
    if [[ $((RANDOM%2)) -eq '0'  ]]; then
        declare -a game=(X O)
    else
        declare -a game=(O X)
    fi
    echo letter assigned to you is ${game[0]} the computer is ${game[1]}
#TOSS FEATURE
    echo Enter 0 for heads and 1 for tails
    read TOSSED
    r=${toss[$((RANDOM%2))]} 
    if [[ "${toss[TOSSED]}" == "$r" ]]; then
        echo Congrats!! you Won the Toss it is $r  
   else
        echo Sorry!! you  Lost the Toss it is ${toss[((TOSSED+1)%2)]}
    fi
}

resetBox(){
declare -a int box
for (( i = 0 ; i < 3 ; i++  )); do
for (( j = 0 ; j < 3 ; j++ )); do
box[$i,$j]=0
echo -n " " ${box[i,j]}" "
done
echo
echo
done
}
resetBox
chooseXorO