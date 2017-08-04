#!/bin/bash
# The Shell Script Of A simple Todo-list
exec 2> /dev/null

function finish {
    arg=$OPTARG
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

function list {
    cat ./.Todo.txt | while read line
    do
        local head=${line:0:1}
        if [ $head = '#' ]
        then
            :
        else
            echo $line
        fi
    done
    echo "Please finish them."
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

while getopts ":alf:" opt
do
    case $opt in
        a)
            add
            ;;
        l)
            list
            ;;
        f)
            finish
            ;;
        ?)
            echo "error"
            exit 1
    esac
done
