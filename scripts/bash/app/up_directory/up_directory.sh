#!/bin/bash
###################################INSTRUCTIONS#################################
# Script argument: Name of directory where you wish to go. Script will use
# backward counting, when your argument will be name of directory.
####################################FUNCTIONS###################################
_up_directory_aux(){
    local target="$1"
    local target_directory=""
    local prepared_current_directory=${PWD:1}

    local IFS="/"
    for word in $prepared_current_directory; do
        if [[ "$word" == "$target" ]]; then
            target_directory+="/$word"
            break
        fi

        target_directory+="/$word"
    done

    cd "$target_directory"
}

_run_up_directory() {
    if [[ -z "$1" ]]; then
        cd "/home/$USER"
    else
        _up_directory_aux "$1"
    fi
}
######################################MAIN######################################
_run_up_directory "$1"
