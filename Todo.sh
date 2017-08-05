#!/bin/bash
# The Shell Script Of A simple Todo-list
exec 2> /dev/null

cp ./zenity.sh .temp.sh
function FinishByNum {
    cat ./.Todo.txt | while read line
    do
        local head=${line:0:1}
        if [ $head = '#' ] || [ $head -lt $arg ]
        then
            echo $line >> .temp
        elif [ $head -eq $arg ]
        then
            temp=${line:1}
            echo '#'$temp >> .temp
        elif [ $head -gt $arg ]
        then
            echo $[ $head - 1 ]${line:1} >> .temp
        fi
    done
    rm .Todo.txt && mv .temp .Todo.txt
}

function FinishFromChecklist {
    count=0
    cat ./.Finished | while read line
    do
        local head=${line:0:1}
        arg=$[ $head - $count ]
        FinishByNum
        count=$[ $count + 1 ]
    done
}

function filter {
    cat ./.Todo.txt | while read line
    do
        local head=${line:0:1}
        if [ $head = '#' ]
        then
            :
        else
            num=$[ $num + 1]
            echo "        $num \"$line\" \\" >> .temp.sh   
        fi
    done
    echo  "        $[ $num + 1 ] \"Please finish them\"" >> .temp.sh
}


function add {
    local sum=`grep -c '[[:digit:]]\..*' .Todo.txt`
    local Input=`zenity --entry \
        --width=300 \
        --height=150 \
        --title="Add new term" \
        --text="Add something to the Todolist" `
    if [ -z $Input ]
    then
        :
    else
        echo $[ sum + 1 ].$Input >> .Todo.txt
    fi
}


while getopts ":alh" opt
do
    case $opt in
        a)
            add
            ;;
        l)
            filter
            bash .temp.sh > .Finished
            FinishFromChecklist
            rm .temp.sh .Finished
            ;;
        h)
            cat ./README.md
        ?)
            echo "error"
            exit 1
    esac
done
