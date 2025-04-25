#!/bin/bash

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

_up_directory() {
    if [[ -z "$1" ]]; then
        cd "/home/$USER"
    else
        _up_directory_aux "$1"
    fi
}

#################################AUTOCOMPLETION#################################
_up_directory_autocompletion()
{
    COMPREPLY=()
    local current_word="${COMP_WORDS[COMP_CWORD]}"
    local possible_words=${PWD:1}

    #It is very important to escape previously set internal field separator.
    local IFS="/"
    local compreply_list=( $(compgen -W "${possible_words}" -- ${current_word}) )
    IFS=$'\n'

    COMPREPLY=($compreply_list)

    return 0
}
