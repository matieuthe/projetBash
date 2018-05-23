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