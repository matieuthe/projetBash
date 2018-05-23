#!/bin/bash

startingPlayer=$(( ( RANDOM % 2 ) + 1 ))
tableau=( 0 0 0 0 0 0 0 0 0 )

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
    clear
    echo ""
    echo "            1     2     3"
    echo "         |-----|-----|-----|"
    echo "    X    |  ${tableau[0]}  |  ${tableau[1]}  |  ${tableau[2]}  |"
    echo "         |-----|-----|-----|"
    echo "    Y    |  ${tableau[3]}  |  ${tableau[4]}  |  ${tableau[5]}  |"
    echo "         |-----|-----|-----|"
    echo "    Z    |  ${tableau[6]}  |  ${tableau[7]}  |  ${tableau[8]}  |"
    echo "         |-----|-----|-----|"
    echo ""
}

function IARandom(){  
    compteur=0
    #On regarde le nombre de case vide
    for i in "${tableau[@]}"
    do
        if [ $i -eq 0 ]
        then
            compteur=$((compteur + 1))
        fi
    done
    
    #On fait un ramdom sur ce nombre
    casePlay=$(( RANDOM % $compteur ))
    compteur=0
    for((i=0; i < 9; i++)){
        echo ${tableau[i]}
        if [ ${tableau[i]} -eq 0 ]
        then
            if [ $compteur -eq $casePlay ]
            then
                tableau[$i]=2
                compteur=$((compteur + 1))
            else
                compteur=$((compteur + 1))
            fi
        fi
    }
    echo $casePlay
}

function checkEnd(){
    if [ ${tableau[0]} -eq ${tableau[1]} ] && [ ${tableau[1]} -eq ${tableau[2]} ] && [ ${tableau[0]} -ne 0 ] ; then echo ${tableau[0]} ; fi
    if [ ${tableau[3]} -eq ${tableau[4]} ] && [ ${tableau[4]} -eq ${tableau[5]} ] && [ ${tableau[3]} -ne 0 ] ; then echo ${tableau[3]} ; fi
    if [ ${tableau[6]} -eq ${tableau[7]} ] && [ ${tableau[7]} -eq ${tableau[8]} ] && [ ${tableau[6]} -ne 0 ] ; then echo ${tableau[6]} ; fi
    
    if [ ${tableau[0]} -eq ${tableau[3]} ] && [ ${tableau[3]} -eq ${tableau[6]} ] && [ ${tableau[6]} -ne 0 ] ; then echo ${tableau[6]} ; fi
    if [ ${tableau[1]} -eq ${tableau[4]} ] && [ ${tableau[4]} -eq ${tableau[7]} ] && [ ${tableau[7]} -ne 0 ] ; then echo ${tableau[7]} ; fi
    if [ ${tableau[2]} -eq ${tableau[5]} ] && [ ${tableau[5]} -eq ${tableau[8]} ] && [ ${tableau[8]} -ne 0 ] ; then echo ${tableau[8]} ; fi
    
    if [ ${tableau[0]} -eq ${tableau[4]} ] && [ ${tableau[4]} -eq ${tableau[8]} ] && [ ${tableau[8]} -ne 0 ] ; then echo ${tableau[7]} ; fi
    if [ ${tableau[2]} -eq ${tableau[4]} ] && [ ${tableau[4]} -eq ${tableau[6]} ] && [ ${tableau[6]} -ne 0 ] ; then echo ${tableau[6]} ; fi
    
    j=5
    for((i=0; i < 9; i++)){
        if [ ${tableau[i]=0} -eq 0 ]
        then
            j=0
        fi
    }
    echo $j
}

function enterCase(){
    echo "Player $currentPlayer turn : Enter case ID (X1, Y3,...)"
    
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
    initGame
    printMap
    while [[ $(checkEnd) = 0 ]]
    do
        enterCase
        changeCurrentPlayer
        printMap
    done
    
    #Come back to choice menu
    menu
}

function gameIANoob(){
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
    
    #Come back to choice menu
    menu
}

function gameIAForte(){
    initGame
    printMap
    iaOrPlayer=1
    while [[ $(checkEnd) = 0 ]]
    do
        if [ $iaOrPlayer -eq 1 ]
        then
            enterCase
            printMap
            iaOrPlayer=0
        else
            IARandom
            printMap
            iaOrPlayer=1
        fi
    done
    
    #come back to the menu
    menu
}

function menu(){        
    echo "What do you want to do ?"
    echo "  1 : Play against a friend"
    echo "  2 : Play against an easy AI"
    echo "  3 : Play against a strong AI"
    echo "  4 : Quit the game"
    
    read choice
    case $choice in
    1) gameOneVsOne;;
    2) gameIANoob;;
    3) gameIAForte;;
    4) echo "Thank you for playing. Bye";;
    *) echo "Enter a valid numbze";
        menu
    esac
}

echo "----------------"
echo "  Tic Tac Toe   "
echo "----------------"
menu