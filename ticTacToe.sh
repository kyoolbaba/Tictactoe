#!/bin/bash
declare -a XandO
declare -a box
declare  place=0
declare -A winner
declare status="change the turn"
declare -a pattern
declare -a cellsInPattern
declare patternSelected
echo "ENter the length"
read n

patternCreation(){
#horizontal patterns
cellsInPattern[((patternCount++))]=0
for (( i=0;i<$n;i++ )); do
    hp=0
    for (( j=1;j<=$n;j++ )); do
        c=$(((n * i )+j))
        cellsInPattern[((patternCount++))]=$c
    done
done
#vertical patterns
for (( i=0;i<$n;i++ )); do
    hp=0
    for (( j=1;j<=$n;j++ )); do
        c=$(((n * (j-1) )+(i+1)))
        cellsInPattern[((patternCount++))]=$c
    done
done
# diagonal one
for (( i=0;i<$n;i++ )); do
    ((diagonalCell1++))   
    c=$(((n*i)+diagonalCell1))
    cellsInPattern[((patternCount++))]=$c
done
#diagonal two
for (( i=1;i<=$n;i++ )); do
    c=$(((n*i)-diagonalCell2))
    cellsInPattern[((patternCount++))]=$c
    ((diagonalCell2++)) 
done
}

assignXorO(){ 
    declare toss=("Heads" "Tails")
    if [[ $((RANDOM%2)) -eq '0'  ]]; then
        XandO=("| X |" "| O |")
        winner=( ["| X |"]="You won the game " ["| O |"]="Computer won the game" )
    else
        XandO=("| O |" "| X |")
        winner=( ["| O |"]="You won the game " ["| X |"]="Computer won the game " )
    fi
    echo letter assigned to you is ${XandO[0]} and the computer is ${XandO[1]}
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
#USED TO CHECK THE STATUS OF PATTERN AT EACH TURN
patternCheck(){
patternValue=0
        for (( p=$((patternRange1+1)) ; p<=$patternRange2 ; p++)) ; do 
                    cellNumber=${cellsInPattern[p]}
             if [[ "${box[cellNumber]}" == "${XandO[1]}"  ]]; then
             patternValue=$((patternValue + 2))
            elif [[ "${box[cellNumber]}" ==  "|___|" ]]; then 
                 patternValue=$((patternValue + 1))  
             elif [[ "${box[cellNumber]}" ==  "${XandO[0]}" ]]; then 
                patternValue=$((patternValue - 2))
            fi
        done
        pattern[((patternCount++))]=$patternValue 
}
#USED FOR SELECT THE PATTERN 
patternSelect(){
    max=0
    for i in ${!pattern[@]}; do
         if [[ $max -lt ${pattern[i]} ]]; then
             max=${pattern[i]}
         fi
    done
     min=$max
    for i in ${!pattern[@]}; do
         if [[ $min -gt ${pattern[i]} ]]; then
            min=${pattern[i]}
         fi
    done
    if [[ $max -eq $((n*2 -1)) ]]; then
        action=$max 
    elif [[ $min -eq $(((-2 *(n-1))+1)) ]]; then
        action=$min
    elif [[ $max -eq $n ]];then
        action=$max
    else
        action=$max
    fi
    for i in ${!pattern[@]};do
        if [[ $action -eq ${pattern[i]} ]]; then
             patternSelected=$i
            break
        fi
    done
}

winCheck(){
patternCount=1
noOfPatterns=$((n+n +2))
for (( i=1;i<=$noOfPatterns;i++ )); do 
patternRange1=$(((i-1)*n))
patternRange2=$((patternRange1+n))
patternCheck
lineMatch=0
    for ((j = $((patternRange1+1)); j <= $patternRange2; j++)); do
    item=${cellsInPattern[j]}
        if [[ "${box[item]}" == "${XandO[count]}" ]]; then
         ((lineMatch++))
        fi 
          if [[ $lineMatch -eq $n ]]; then
         XO="${XandO[count]}" 
         status=${winner[$XO]}
         break
        fi
    done 
done
patternSelect #echo ${pattern[@]}
}

checkFilledOrNot(){
 while [[ true ]]; do
        cellNotUsed=0
        cellsFilled=${#filledUpCells[@]}
            for (( i = 0 ; i < $((cellsFilled+1)) ; i++  )); do
                if [[ ${filledUpCells[$i]} -eq $place ]]; then
                    cellNotUsed=1
                     echo The Cell is already occupied please select another cell
                    read place
                 elif [[ $place -gt $((n*n)) ]]; then
                    cellNotUsed=1
                     echo The Cell you entered is out of range
                    read place
                fi
            done   
        if [[ $cellNotUsed -eq '0' ]]; then
            filledUpCells[((filledplace++))]=$place
            break
        fi
     done
}

computerchoices() {
p=$(((patternSelected -1) * n))
patternRange2=$((patternRange1+n))
echo $patternRange2 and $p
if [[ $k -eq '0' ]]; then
   place=1
else
    for (( h=$((p+1)) ; h<=$patternRange2 ; h++ ))  ;do
    item=${cellsInPattern[h]}
        if [[ "${box[item]}" == "|___|"  ]];then
            place=$item
            break
        fi
    done
fi
}

startgame(){
    for (( k = 0 ; k < $((n*n)) ; k++  )); do
    chances=0
        if [[ "${XandO[0]}" == "${XandO[count]}"  ]]; then
            echo Enter the cell that you want to enter the ${XandO[count]}
            read place
            checkFilledOrNot
        elif [[  "${XandO[1]}" == "${XandO[count]}" ]]; then
            echo Computer entered the ${XandO[count]}
            computerchoices
             checkFilledOrNot
        fi
        Box $place
        winCheck
        if [[ "$status" != 'change the turn' ]]; then
            echo $status
            break
        fi
        count=$(((count+1)%2)) #CHANGING TURN
        if [[ $chances -eq $((n*n-1)) ]]; then
        status="Its a Tie"
        echo $status
        break
        fi
    done
}
Box(){
task=$1
cell=1
for (( i = 0 ; i < $n ; i++  )); do
    for (( j = 0 ; j < $n ; j++ )); do
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
patternCreation
Box "reset"
assignXorO
startgame