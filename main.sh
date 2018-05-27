#!/bin/bash

startingPlayer=$(( ( RANDOM % 2 ) + 1 ))
tableau=( 0 0 0 0 0 0 0 0 0 )
gameType=""

function initGame(){
    #Change the person who start
    startingPlayer=$(( ( $startingPlayer % 2 ) + 1 ))
    
    currentPlayer=$startingPlayer
    #init the element of table to 0
    for((i=0; i < 9; i++)){
        tableau[i]=0
    }  
}

function changeCurrentPlayer(){
    currentPlayer=$(( ( $currentPlayer % 2 ) + 1 ))
}

function printMap(){
    
    if [[ ${tableau[0]} -eq 0 ]] ; then case0=" " ; elif [[ ${tableau[0]} -eq 1 ]] ; then case0="X" ; else case0="O" ; fi
    if [[ ${tableau[1]} -eq 0 ]] ; then case1=" " ; elif [[ ${tableau[1]} -eq 1 ]] ; then case1="X" ; else case1="O" ; fi
    if [[ ${tableau[2]} -eq 0 ]] ; then case2=" " ; elif [[ ${tableau[2]} -eq 1 ]] ; then case2="X" ; else case2="O" ; fi
    
    if [[ ${tableau[3]} -eq 0 ]] ; then case3=" " ; elif [[ ${tableau[3]} -eq 1 ]] ; then case3="X" ; else case3="O" ; fi
    if [[ ${tableau[4]} -eq 0 ]] ; then case4=" " ; elif [[ ${tableau[4]} -eq 1 ]] ; then case4="X" ; else case4="O" ; fi
    if [[ ${tableau[5]} -eq 0 ]] ; then case5=" " ; elif [[ ${tableau[5]} -eq 1 ]] ; then case5="X" ; else case5="O" ; fi
    
    if [[ ${tableau[6]} -eq 0 ]] ; then case6=" " ; elif [[ ${tableau[6]} -eq 1 ]] ; then case6="X" ; else case6="O" ; fi
    if [[ ${tableau[7]} -eq 0 ]] ; then case7=" " ; elif [[ ${tableau[7]} -eq 1 ]] ; then case7="X" ; else case7="O" ; fi
    if [[ ${tableau[8]} -eq 0 ]] ; then case8=" " ; elif [[ ${tableau[8]} -eq 1 ]] ; then case8="X" ; else case8="O" ; fi
    
    if [[ $gameType == "1 Vs 1 game" ]] ; then advName="Your friend" ; else advName="AI" ; fi
    
    clear
    echo 
    echo "      " $gameType
    echo 
    echo "        X " $namePlayer
    echo "        O " $advName
    echo
    echo "            1     2     3"
    echo "         |-----|-----|-----|"
    echo "    X    |  $case0  |  $case1  |  $case2  |"
    echo "         |-----|-----|-----|"
    echo "    Y    |  $case3  |  $case4  |  $case5  |"
    echo "         |-----|-----|-----|"
    echo "    Z    |  $case6  |  $case7  |  $case8  |"
    echo "         |-----|-----|-----|"
    echo ""
}

printFinalMessage(){
    echo 
    if [[ $gameType == "1 Vs 1 game" ]] ; then advName="Your friend" ; else advName="AI" ; fi
    
    if [ $(checkEnd) -eq 1 ]
    then
        echo "You win the game !! "
    elif [ $(checkEnd) -eq 2 ]
    then
        echo $advName " win the game !!"
    else
        echo "It's a draw !!"
    fi
    echo
}


function IARandom(){  
    compteur=0
    #On regarde le nombre de case vide
    for i in "${tableau[@]}"
    do
        if [ $i -eq 0 ]
        then
            compteur=$(( $compteur + 1 ))
        fi
    done

    #On fait un ramdom sur ce nombre
    casePlay=$(( RANDOM % $compteur ))
    compteur=0
    for((i=0; i < 9; i++)){
        if [ ${tableau[i]} -eq 0 ]
        then
            if [ $compteur -eq $casePlay ]
            then
                tableau[$i]=2
                break
            else
                compteur=$(( $compteur + 1 ))
            fi
        fi
    }
}

IAMinMaxOpt(){
    nbEmptyCase=0
    #Count number of empty case and get their id
    for i in "${tableau[@]}"
    do
        if [ $i -eq 0 ]
        then
            nbEmptyCase=$(( $nbEmptyCase + 1 ))
        fi
    done
    
    if [ $nbEmptyCase -eq 9 ]
    then
        local randStart=$(( RANDOM % 4 ))
        if [ $randStart -eq 0 ]
        then 
            bestmoove=0
        elif [ $randStart -eq 1 ]
        then 
            bestmoove=2
        elif [ $randStart -eq 2 ]
        then 
            bestmoove=6
        else
            bestmoove=8
        fi
    else
        IACalcMax
    fi  
}

IACalcMin(){
    tempCheck=$(checkEnd)
    #If the game is finish
    if [[ $tempCheck -ne 0 ]]
    then
        if [[ $tempCheck -eq 2 ]]
        then
            scoreMinMax=10
        elif [[ $tempCheck -eq 1 ]]
        then
            scoreMinMax=-10
        else 
            scoreMinMax=0
        fi
    else
        local caseVide=()
        indexCase=0
        #Count number of empty case and get their id
        for i in "${tableau[@]}"
        do
            if [ $i -eq 0 ]
            then
                caseVide+=($indexCase)
            fi
            indexCase=$(( $indexCase + 1 ))
        done
        
        local bestTemp=-1
        local scoreTemp=1000
        
        for i in "${caseVide[@]}"
        do
            tableau[$i]=1
            local stockItemp=$i
            IACalcMax
            i=$stockItemp
            tableau[$i]=0
            if [[ $scoreTemp -gt $scoreMinMax ]]
            then
                local scoreTemp=$scoreMinMax
                local bestTemp=$i
                if [[ $scoreTemp -eq -10 ]]
                then
                    break
                fi
            fi
        done
        scoreMinMax=$scoreTemp
        bestmoove=$bestTemp
    fi
}

IACalcMax(){
    tempCheck=$(checkEnd)
    #If the game is finish
    if [[ $tempCheck -ne 0 ]]
    then
        if [[ $tempCheck -eq 2 ]]
        then
            scoreMinMax=10
        elif [[ $tempCheck -eq 1 ]]
        then
            scoreMinMax=-10
        else 
            scoreMinMax=0
        fi
    else
        local caseVide=()
        indexCase=0
        #Count number of empty case and get their id
        for i in "${tableau[@]}"
        do
            if [ $i -eq 0 ]
            then
                caseVide+=($indexCase)
            fi
            indexCase=$(( $indexCase + 1 ))
        done
        
        local bestTemp=-1
        local scoreTemp=-1000
        
        for i in "${caseVide[@]}"
        do
            tableau[$i]=2
            local stockItemp=$i
            IACalcMin
            i=$stockItemp
            tableau[$i]=0
            if [[ $scoreTemp -lt $scoreMinMax ]]
            then
                local scoreTemp=$scoreMinMax
                local bestTemp=$i
                if [[ $scoreTemp -eq 10 ]]
                then
                    break
                fi
            fi
        done
        scoreMinMax=$scoreTemp
        bestmoove=$bestTemp
    fi
}


function checkEnd(){
    if [ ${tableau[0]} -eq ${tableau[1]} ] && [ ${tableau[1]} -eq ${tableau[2]} ] && [ ${tableau[0]} -ne 0 ] ; then echo ${tableau[0]} ; 
    elif [ ${tableau[3]} -eq ${tableau[4]} ] && [ ${tableau[4]} -eq ${tableau[5]} ] && [ ${tableau[3]} -ne 0 ] ; then echo ${tableau[3]} ;
    elif [ ${tableau[6]} -eq ${tableau[7]} ] && [ ${tableau[7]} -eq ${tableau[8]} ] && [ ${tableau[6]} -ne 0 ] ; then echo ${tableau[6]} ; 
    
    elif [ ${tableau[0]} -eq ${tableau[3]} ] && [ ${tableau[3]} -eq ${tableau[6]} ] && [ ${tableau[6]} -ne 0 ] ; then echo ${tableau[6]} ; 
    elif [ ${tableau[1]} -eq ${tableau[4]} ] && [ ${tableau[4]} -eq ${tableau[7]} ] && [ ${tableau[7]} -ne 0 ] ; then echo ${tableau[7]} ; 
    elif [ ${tableau[2]} -eq ${tableau[5]} ] && [ ${tableau[5]} -eq ${tableau[8]} ] && [ ${tableau[8]} -ne 0 ] ; then echo ${tableau[8]} ; 
    
    elif [ ${tableau[0]} -eq ${tableau[4]} ] && [ ${tableau[4]} -eq ${tableau[8]} ] && [ ${tableau[8]} -ne 0 ] ; then echo ${tableau[8]} ; 
    elif [ ${tableau[2]} -eq ${tableau[4]} ] && [ ${tableau[4]} -eq ${tableau[6]} ] && [ ${tableau[6]} -ne 0 ] ; then echo ${tableau[6]} ; 
    else
        j=5
        for((i=0; i < 9; i++)){
            if [ ${tableau[i]=0} -eq 0 ]
            then
                j=0
                break
            fi
        }
        echo $j
    fi
}

function enterCase(){
    if [[ $currentPlayer -eq 1 ]]
    then
        echo "$namePlayer : Please enter case ID (X1, Y3,...)"
    else
        echo "$namePlayer's friend : Please enter case ID (X1, Y3,...)"
    fi
    
    read caseID
    case $caseID in
    X1) if [ ${tableau[0]} -eq 0 ]
        then
            tableau[0]=$currentPlayer
        else
            echo "This case is not empty"
            enterCase
        fi;;
    X2) if [ ${tableau[1]} -eq 0 ]
        then
            tableau[1]=$currentPlayer
        else
            echo "This case is not empty"
            enterCase
        fi;;
    X3) if [ ${tableau[2]} -eq 0 ]
        then
            tableau[2]=$currentPlayer
        else
            echo "This case is not empty"
            enterCase
        fi;;
    Y1) if [ ${tableau[3]} -eq 0 ]
        then
            tableau[3]=$currentPlayer
        else
            echo "This case is not empty"
            enterCase
        fi;;
    Y2) if [ ${tableau[4]} -eq 0 ]
        then
            tableau[4]=$currentPlayer
        else
            echo "This case is not empty"
            enterCase
        fi;;
    Y3) if [ ${tableau[5]} -eq 0 ]
        then
            tableau[5]=$currentPlayer
        else
            echo "This case is not empty"
            enterCase
        fi;;
    Z1) if [ ${tableau[6]} -eq 0 ]
        then
            tableau[6]=$currentPlayer
        else
            echo "This case is not empty"
            enterCase
        fi;;
    Z2) if [ ${tableau[7]} -eq 0 ]
        then
            tableau[7]=$currentPlayer
        else
            echo "This case is not empty"
            enterCase
        fi;;
    Z3) if [ ${tableau[8]} -eq 0 ]
        then
            tableau[8]=$currentPlayer
        else
            echo "This case is not empty"
            enterCase
        fi;;
    *) echo "Not a case !";
        enterCase
    esac
}


function gameOneVsOne(){
    gameType="1 Vs 1 game"
    initGame
    printMap
    while [[ $(checkEnd) = 0 ]]
    do
        enterCase
        changeCurrentPlayer
        printMap
    done
    printFinalMessage
    #Come back to choice menu
    menu
}

function gameIANoob(){
    gameType="Game against an esay AI"
    initGame
    printMap
    while [[ $(checkEnd) = 0 ]]
    do
        if [ $currentPlayer -eq 1 ]
        then
            enterCase
            printMap
            changeCurrentPlayer
        else
            IARandom
            printMap
            changeCurrentPlayer
        fi
    done
    printFinalMessage
    #Come back to choice menu
    menu
}

function gameIAStrong(){
    gameType="Game against a strong AI"
    initGame
    printMap
    while [[ $(checkEnd) = 0 ]]
    do
        if [ $currentPlayer -eq 1 ]
        then
            enterCase
            printMap
            changeCurrentPlayer
        else
            echo "IA is playing... (it may take a while)"
            IAMinMaxOpt
            tableau[$bestmoove]=2
            printMap
            changeCurrentPlayer
        fi
    done
    printFinalMessage
    #come back to the menu
    menu
}

function menu(){        
    echo "What do you want to do $namePlayer ?"
    echo "  1 : Play against a friend"
    echo "  2 : Play against an easy AI"
    echo "  3 : Play against a strong AI"
    echo "  4 : Quit the game"
    
    read choice
    case $choice in
    1) gameOneVsOne;;
    2) gameIANoob;;
    3) gameIAStrong;;
    4) echo "Thank you for playing. Bye";;
    *) echo "Enter a valid numbze";
        menu
    esac
}

clear
echo "----------------"
echo "  Tic Tac Toe   "
echo "----------------"
echo ""
echo "Please enter your name :"
read namePlayer

echo ""

menu