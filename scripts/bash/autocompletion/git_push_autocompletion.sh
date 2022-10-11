#!/bin/bash
####################################INSTRUCTIONS#################################
#Script argument: None
#####################################FUNCTIONS###################################
_git_push_autocompletion()
{
    COMPREPLY=()

    local current_word="${COMP_WORDS[COMP_CWORD]}"
    local possible_words="private draft master main"

    COMPREPLY=( $(compgen -W "${possible_words}" -- ${current_word}) )

    return 0
}

complete -o nospace -F _git_push_autocompletion git-push
