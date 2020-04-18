#!/bin/bash
declare -a XandO
declare -a box
declare  place=0
declare -A winner
declare status="change the turn"

assignXorO(){ 
#ASSIGNING X OR O FEATURE
    declare toss=("Heads" "Tails")
    if [[ $((RANDOM%2)) -eq '0'  ]]; then
        XandO=("| X |" "| O |")
        winner=( ["| X |"]="You won the game " ["| O |"]="Computer won the game" )
    else
        XandO=("| O |" "| X |")
        winner=( ["| O |"]="You won the game " ["| X |"]="Computer won the game "] )
    fi
    echo letter assigned to you is ${XandO[0]} and the computer is ${XandO[1]}
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

wincheck(){
n=3
#VERTICAL CHECK
add=1
    for (( i = 0 ; i < 3 ; i++  )); do
        a=$(((n*0)+add))  b=$(((n*1)+add)) c=$(((n*2)+add))
        if [[ "${box[a]}" == "${XandO[count]}" && "${box[b]}" == "${XandO[count]}" && "${box[c]}" == "${XandO[count]}" ]]; then
            XO="${XandO[count]}"
            status=${winner[$XO]}
        fi 
        ((add++))
    done
#HORIZONTAL CHECK
add=0
    for (( i = 0 ; i < 3 ; i++  )); do
        a=$(((n*add)+1)); b=$(((n*add)+2)); c=$(((n*add)+3))
        if [[ "${box[a]}" == "${XandO[count]}" && "${box[b]}" == "${XandO[count]}" && "${box[c]}" == "${XandO[count]}" ]]; then
            XO="${XandO[count]}"
            status=${winner[$XO]}
        fi 
        ((add++))
    done

#Diagonal Check
    a=$(((n*0)+1)); b=$(((n*1)+2)); c=$(((n*2)+3))
    if [[ "${box[a]}" == "${XandO[count]}" && "${box[b]}" == "${XandO[count]}" && "${box[c]}" == "${XandO[count]}" ]]; then
        XO="${XandO[count]}"
        status=${winner[$XO]}
    fi
    a=$(((n*1)-(add))) ; b=$(((n*2)-1)); c=$(((n*3)-2))
    if [[ "${box[a]}" == "${XandO[count]}" && "${box[b]}" == "${XandO[count]}" && "${box[c]}" == "${XandO[count]}" ]]; then
        XO="${XandO[count]}"
            status=${winner[$XO]}
    fi
}

startgame(){
    for (( k = 0 ; k < 9 ; k++  )); do
        echo Enter the cell that you want to enter the ${XandO[count]}
        read place
        while [[ true ]]; do
            cellNotUsed=0
            cellsFilled=${#filledUpCells[@]}
                for (( i = 0 ; i < $((cellsFilled+1)) ; i++  )); do
                if [[ ${filledUpCells[$i]} -eq $place ]]; then
                    cellNotUsed=1
                    echo The Cell is already occupied please select another cell
                    read place
                fi
                done   
            if [[ $cellNotUsed -eq '0' ]]; then
                filledUpCells[((filledplace++))]=$place
                break
            fi
        done
        Box $place
        wincheck
        if [[ "$status" != 'change the turn' ]]; then
            echo $status
            break
        fi
        count=$(((count+1)%2))
        if [[ $k -eq '8' ]]; then
        status="Its a Tie"
        echo $status
        fi
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
                box[$cell]=${XandO[count]}
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
