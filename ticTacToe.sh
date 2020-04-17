#!/bin/bash
declare -a XO
chooseXorO(){ 
if [[ $((RANDOM%2)) -eq '0'  ]]; then
    PLAYER=X
    COMPUTER=O
else
    PLAYER=O
    COMPUTER=X
fi
echo letter assigned to you is $PLAYER the computer is $COMPUTER 
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