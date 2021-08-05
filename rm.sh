#!/usr/bin/env bash

TRASH_DIR="${TRASH_DIR:-$HOME/.local/trash}"
[[ ! -d "${TRASH_DIR}" ]] && mkdir "${TRASH_DIR}"

Help() {
    echo "rm.sh 0.1.0 by @matdexir"
    echo ""
    echo "DESCRIPTION:"
    echo -e "This program is a rm replacement for sloppy just like me. It is essentially a wrapper for rm and mv commands."
    echo ""
    echo "OPTIONS:"
    echo -e "\t-h|--help:\tDisplays the current help message"
    echo -e "\t-e|--empty:\tEmpties the trash directory defined by ${TRASH_DIR}"
    echo -e "\t-c|--clear:\tClears the file that are older than 30 days inside ${TRASH_DIR}"
}

Main() {
    for i in ${@}; do
        STAMP=$(date +%s)
        NAME=$(basename ${i})
        mv "${i}" "${TRASH_DIR}/${NAME}.${STAMP}"
    done
}

Empty() {
    echo "Emptying ${TRASH_DIR}..."
    files=$(ls ${TRASH_DIR})
    
    if [[ -z ${files} ]]; then
        echo "${TRASH_DIR} is empty"
        exit 1
    fi
    
    for f in ${files}; do
        rm -rf ${TRASH_DIR}/${f}
    done
    echo "Done."
}

Clear() {
    echo "Clearing ${TRASH_DIR}..."
    files=$(ls ${TRASH_DIR})
    
    if [ -z $files ]; then
        echo "${TRASH_DIR} is empty"
        exit 1
    fi
    
    for i in $files; do 
        f=$(echo "$i" |rev |cut -d "." -f1 |rev)
        echo "$f and $i"
        DATE=$(date +%s)
        MONTH=60*60*24*30
        DIFF=$(expr $((${DATE}-${f})))
        echo ${DIFF}
        if [[ ${DIFF} -gt ${MONTH} ]]; then
            rm -rf ${i}
        else
            echo "Not deleting ${i}"
        fi
    done
    echo "Done."
}

FILES=""

while (( "$#" )); do
    case "$1" in
        -h|--help) # Display help message
            Help
            exit 0
            ;;
        -e|--empty) # Emptying TRASH_DIR
            Empty
            exit 0
            ;;
        -c|--clear) # Delete any file older than the time period
            Clear
            exit 0
            ;;
        -*|--*=) # Unknown option
            echo "Error: Unknown option" >&2
            exit 1
            ;;
        *) # Arguments to be deleted
            FILES="${FILES} $1"
            shift 1
            ;;
    esac
done

eval set -- "${FILES}"
Main ${FILES}
