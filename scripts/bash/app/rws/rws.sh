#!/bin/bash
####################################INSTRUCTIONS#################################
#Script arguments: List of files, which we want to clean from redundant whitespaces.
####################################FUNCTIONS####################################
_remove_redundant_spaces(){
    sed -i 's/[[:blank:]]*$//' "$1"
}

_remove_last_empty_line(){
    sed -i '${/^$/d;}' "$1"
}

_remove_white_spaces(){
    remove_redundant_spaces "$1"
    remove_last_empty_line "$1"
}
#################################################################################

all_files=("$*")

for file in $all_files; do
    _remove_white_spaces "$file"
done
