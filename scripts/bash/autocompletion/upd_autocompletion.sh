#!/bin/bash
####################################INSTRUCTIONS#################################
#Script argument: None
#####################################FUNCTIONS###################################
_upd_autocompletion()
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

complete -o nospace -F _upd_autocompletion upd
