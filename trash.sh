#!/usr/bin/env bash

THRASH_DIR="${THRASH_DIR:-$HOME/.local/trash}"
[[ ! -d "${THRASH_DIR}" ]] && mkdir "${THRASH_DIR}"

ARGS=$@

Help() {
    echo -e "This program is a rm replacement for sloppy just like me"
    echo -e "\t It is still in its early days but for now we only have 2 options"
    echo -e "\t\t -e: to empty the trash directory defined by ${THRASH_DIR}"
    echo -e "\t\t -d: to delete any file older than 30days old from ${THRASH_DIR}"
}

Main() {
    for i in ${ARGS}; do
        case $i in 
            -h|-d|-e) 
                continue;;
        esac
        STAMP=$(date +%s)
        NAME=$(basename $i)
        mv $i "${THRASH_DIR}/${NAME}.${STAMP}"
    done
}

Empty() {
    files=$(ls ${THRASH_DIR})
    for f in ${files}; do
        rm -rf ${THRASH_DIR}/${f}
    done
}

Clear() {
    files=$(ls ${THRASH_DIR})
    for i in $files; do 
        f=$(echo "$i" |rev |cut -d "." -f1 |rev)
        echo "$f and $i"
        DATE=$(date +%s)
        MONTH=60*60*24*30
        DIFF=$(expr $((${DATE}-${f})))
        echo ${DIFF}
        if [[ ${DIFF} -gt ${MONTH} ]]; then
            rm -rf $i
        else
            echo "Not deleting $i"
        fi
    done
}

while getopts ched: option; do
    case $option in
        h) # Display help message
            Help
            exit;;
        e) # Emptying THRASH_DIR
            echo "Emptying ${THRASH_DIR}..."
            Empty
            exit;;
        d) # Send a file to THRASH_DIR
            Main
            exit;;
        c) # Delete any file older than the time period
            Clear
            exit;;
        \?) # Unknown option
            echo "Error: Unknown option"
            exit;;
    esac
done

