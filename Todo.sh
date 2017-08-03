#!/bin/bash
# The Shell Script Of A simple Todo-list

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
            local finished=${line:1}
        elif [ $head -gt $arg ]
        then
            echo $[ $head - 1 ]${line:1} >> .temp
        fi
    done
    echo '#'$finished >> .temp
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
    echo $[ sum + 1 ].$OPTARG >> .Todo.txt
}

while getopts ":a:lf:" opt
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
