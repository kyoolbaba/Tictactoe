#!/bin/bash

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
