#!/usr/bin/env bash

TRASH_DIR="${TRASH_DIR:-$HOME/.local/trash}"
[[ ! -d "${TRASH_DIR}" ]] && mkdir "${TRASH_DIR}"

TRASH_INFO_DIR="${TRASH_INFO_DIR:-${TRASH_DIR}/info}"
[[ ! -d "${TRASH_INFO_DIR}" ]] && mkdir "${TRASH_INFO_DIR}"

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
    echo -e "\t-l|--list:\tLists out all the file inside ${TRASH_DIR}"
}

# TODO:
# 1. Reimplement how the file are save on the system
# 2. This feature should heavily rely on the TRASH_INFO_DIR
# 3. What to save:
#       - File former directory(Later I will implement Restore)
#       - File last modification Date for 
#       - Other useful metadata that is permission and so on
SaveInfo() {
    echo "Saving file info into ${TRASH_INFO_DIR}..."
}

# TODO:
# 1. Save the files information with the function SaveInfo
# 2. Hash the file out for basic privacy feature 
Main() {
    for i in ${@}; do
        STAMP=$(date +%s)
        NAME=$(basename "${i}")
        mv "${i}" "${TRASH_DIR}/${NAME}.${STAMP}"
    done
}

Empty() {
    echo "Emptying ${TRASH_DIR}..."
    files=$(ls "${TRASH_DIR}")
    
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
    files=$(ls "${TRASH_DIR}")
    
    if [[ -z ${files} ]]; then
        echo "${TRASH_DIR} is empty"
        exit 1
    fi
    
    for i in ${files}; do 
        if [[ ! $i == "info" ]]; then
            f=$(echo "${i}" |rev |cut -d "." -f1 |rev)
            DATE=$(date +%s)
            MONTH=60*60*24*30
            DIFF=$(expr $((${DATE}-${f})))
            if [[ ${DIFF} -gt ${MONTH} ]]; then
                rm -rf "${i}"
            else
                echo "Not deleting ${i}"
            fi
        fi
    done
    echo "Done."
}

List() {
    # This feature should parse the Files inside $TRASH_DIR and return a pretty formatted list
    echo "Feature Not Done Yet :(...."
    files=$(ls "${TRASH_DIR}")

    if [[ -z $files ]]; then
        echo "No files to show"
        exit 1
    fi

    for i in $files; do
        if [[ ! $i == "info" ]]; then
            f=$(echo "$i" |rev |cut -d "." -f1 |rev)
            filedate=$(date -d @"${f}")
            echo "$filedate" "$i"
        fi

    done
}

FILES=""

while (( "$#" )); do
    case "$1" in
        -h|--help) # Display help message
            Help
            exit 1
            ;;
        -e|--empty) # Emptying TRASH_DIR
            Empty
            exit 1
            ;;
        -c|--clear) # Delete any file older than the time period
            Clear
            exit 1
            ;;
        -l|--list)
            List
            exit 1
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
