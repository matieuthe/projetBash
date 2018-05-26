#Function use to check if one user win the game or it's a draw
function checkEndGame(){
    if [ $X1 -eq $X2 ] && [ $X2 -eq $X3 ] && [ $X3 -ne 0 ] ; then echo $X3 ; fi
    if [ $Y1 -eq $Y2 ] && [ $Y2 -eq $Y3 ] && [ $Y3 -ne 0 ] ; then echo $Y3 ; fi
    if [ $Z1 -eq $Z2 ] && [ $Z2 -eq $Z3 ] && [ $Z3 -ne 0 ] ; then echo $Z3 ; fi

    if [ $X1 -eq $Y1 ] && [ $Y1 -eq $Z1 ] && [ $Z1 -ne 0 ] ; then echo $Z1 ; fi
    if [ $X2 -eq $Y2 ] && [ $Y2 -eq $Z2 ] && [ $Z2 -ne 0 ] ; then echo $Z2 ; fi
    if [ $X3 -eq $Y3 ] && [ $Y3 -eq $Z3 ] && [ $Z3 -ne 0 ] ; then echo $Z3 ; fi

    if [ $X1 -eq $Y2 ] && [ $Y2 -eq $Z3 ] && [ $Z3 -ne 0 ] ; then echo $Z3 ; fi
    if [ $X3 -eq $Y2 ] && [ $Y2 -eq $Z1 ] && [ $Z1 -ne 0 ] ; then echo $Z1 ; fi
    
    if [ $X1 -ne 0 ] && [ $X2 -ne 0 ] && [ $X3 -ne 0 ] && [ $Y1 -ne 0 ] && [ $Y2 -ne 0 ] && [ $Y3 -ne 0 ] && [ $Z1 -ne 0 ] && [ $Z2 -ne 0 ] && [ $Z3 -ne 0 ] ; then echo 5 ; fi
    
    echo 0
}


function playPlayer(){
 echo "Player $currentPlayer turn : Enter case ID (X1, Y3,...)"
    read caseID
    case $caseID in
    X1) if [ $X1 -eq 0 ]
        then
            X1=$currentPlayer
        else
            echo "This case is not empty"
            playPlayer
        fi;;
    X2) if [ $X2 -eq 0 ]
        then
            X2=$currentPlayer
        else
            echo "This case is not empty"
            playPlayer
        fi;;
    X3) if [ $X3 -eq 0 ]
        then
            X3=$currentPlayer
        else
            echo "This case is not empty"
            playPlayer
        fi;;
    Y1) if [ $Y1 -eq 0 ]
        then
            Y1=$currentPlayer
        else
            echo "This case is not empty"
            playPlayer
        fi;;
    Y2) if [ $Y2 -eq 0 ]
        then
            Y2=$currentPlayer
        else
            echo "This case is not empty"
            playPlayer
        fi;;
    Y3) if [ $Y3 -eq 0 ]
        then
            Y3=$currentPlayer
        else
            echo "This case is not empty"
            playPlayer
        fi;;
    Z1) if [ $Z1 -eq 0 ]
        then
            Z1=$currentPlayer
        else
            echo "This case is not empty"
            playPlayer
        fi;;
    Z2) if [ $Z2 -eq 0 ]
        then
            Z2=$currentPlayer
        else
            echo "This case is not empty"
            playPlayer
        fi;;
    Z3) if [ $Z3 -eq 0 ]
        then
            Z3=$currentPlayer
        else
            echo "This case is not empty"
            playPlayer
        fi;;
    *) echo "Not a case !";
        playPlayer
    esac
}

function IAMinMax(){
    #If the game is finish
    if [[ $(checkEnd) -ne 0 ]]
    then
        if [[ $(checkEnd) -eq 5 ]]
        then
            scoreMinMax=0
        elif [[ $(checkEnd) -eq 1 ]]
        then
            scoreMinMax=-10
        else 
            scoreMinMax=10
        fi
    else
        nbEmpty=0
        local caseVide=()
        indexCase=0
        #Count number of empty case and get their id
        for i in "${tableau[@]}"
        do
            if [ $i -eq 0 ]
            then
                nbEmpty=$(( $nbEmpty + 1 ))
                caseVide+=($indexCase)
            fi
            indexCase=$(( $indexCase + 1 ))
        done
        
        local scoreFree=()
        compteur=0
        for i in "${caseVide[@]}"
        do
            tableau[$i]=$currentPlayer
            changeCurrentPlayer
            local stockItemp=$i
            IAMinMax
            i=$stockItemp
            scoreFree+=($scoreMinMax)
            compteur=$(( $compteur + 1 ))
            changeCurrentPlayer
            tableau[$i]=0
        done
        
        bestmoove=-1
        scoreMinMax=0
        compteur=0
        if [[ $currentPlayer -eq 2 ]]
        then
            scoreMinMax=-1000
            for i in "${scoreFree[@]}"
            do
                if [[ $scoreMinMax -lt $i ]]
                then
                    scoreMinMax=$i
                    bestmoove=${caseVide[$compteur]}
                fi
                compteur=$(( $compteur + 1 ))
            done
        else
            scoreMinMax=1000
            for i in "${scoreFree[@]}"
            do
                if [[ $scoreMinMax -gt $i ]]
                then
                    scoreMinMax=$i
                    bestmoove=${caseVide[$compteur]}
                fi
                compteur=$(( $compteur + 1 ))
            done
        fi
    fi
}


function IAMinMaxOpt(){
    #If the game is finish
    if [[ $(checkEnd) -ne 0 ]]
    then
        if [[ $(checkEnd) -eq 5 ]]
        then
            scoreMinMax=0
        elif [[ $(checkEnd) -eq 1 ]]
        then
            scoreMinMax=-10
        else 
            scoreMinMax=10
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
        if [[ $currentPlayer -eq 2 ]]
        then
            local scoreTemp=-1000
        else
            local scoreTemp=1000
        fi
        
        local comptTemp=0
        for i in "${caseVide[@]}"
        do
            tableau[$i]=$currentPlayer
            changeCurrentPlayer
            local stockItemp=$i
            IAMinMaxOpt
            i=$stockItemp
            changeCurrentPlayer
            tableau[$i]=0
            if [[ $currentPlayer -eq 2 ]] && [[ $scoreTemp -lt $scoreMinMax ]]
            then
                local scoreTemp=$scoreMinMax
                local bestTemp=${caseVide[$comptTemp]}
            elif [[ $currentPlayer -eq 1 ]] && [[ $scoreTemp -gt $scoreMinMax ]]
            then
                local scoreTemp=$scoreMinMax
                local bestTemp=${caseVide[$comptTemp]}
            fi
            local comptTemp=$(( $comptTemp + 1))
        done
        scoreMinMax=$scoreTemp
        bestmoove=$bestTemp
    fi
}


#Avant modif sur tableau
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