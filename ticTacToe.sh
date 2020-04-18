#!/bin/bash
declare -a game
declare place=0

assignXorO(){ 
#ASSIGNING X OR O FEATURE
    declare toss=("Heads" "Tails")
    if [[ $((RANDOM%2)) -eq '0'  ]]; then
        game=("| X |" "| O |")
    else
        game=("| O |" "| X |")
    fi
    echo letter assigned to you is ${game[0]} the computer is ${game[1]}
#TOSS FEATURE
    echo Enter 0 for heads and 1 for tails
    read TOSSED
    r=${toss[$((RANDOM%2))]} 
    if [[ "${toss[TOSSED]}" == "$r" ]]; then
        echo Congrats!! you Won the Toss it is $r  
        count=0
   else
        echo Sorry!! you  Lost the Toss it is ${toss[((TOSSED+1)%2)]}
        count=1
    fi
}

startgame(){
    for (( k = 0 ; k < 9 ; k++  )); do
    echo Enter the cell that you want to enter the ${game[count]}
    read place
    Box $place
    count=$(((count+1)%2))
    done
}
Box(){
task=$1
cell=1
for (( i = 0 ; i < 3 ; i++  )); do
    for (( j = 0 ; j < 3 ; j++ )); do
        if [[ "$task" == "reset" ]]; then 
            box[$cell]="|___|"
            echo -n " " ${box[$cell]}" "
        else
            if [[ $cell -eq $task ]]; then
                box[$cell]=${game[count]}
                echo -n " " ${box[$cell]}" " 
            else 
                 echo -n " " ${box[$cell]}" " 
             fi   
        fi
        ((cell++))    
    done
    echo;echo
done
}

Box "reset"
assignXorO
startgame