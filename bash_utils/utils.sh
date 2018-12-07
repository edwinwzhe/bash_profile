### COMMAND: CD
mycd() {
    if [[ $# -ge 2 ]]
    then
        if [[ `expr $# % 2` -ne 0 ]]
        then
            echo "ERR (mycd): Uneven number of params passed."
            return 1
        fi

        toDir=`pwd`
        from=''

        for i in $@
        do
            if [[ $from == '' ]]
            then
                from=$i
            else
                to=$i
                toDir=`echo $toDir | sed "s/$from/$to/g"`
                from=''
            fi
        done

        builtin cd $toDir
    else
        builtin cd $*
    fi
}

alias cd='mycd'
