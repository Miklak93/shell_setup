#!/bin/bash
####################################INSTRUCTIONS#################################
#Script argument: None
#####################################FUNCTIONS###################################
_directory_navigator_helper_autocompletion() {
    COMPREPLY=()
    local current_word="${COMP_WORDS[COMP_CWORD]}"
    local possible_words="$($BASH_SCRIPTS_PATH/directory_navigator/directory_navigator_helper.sh _keys)"

    COMPREPLY=( $(compgen -W "${possible_words}" -- ${current_word}) )
    return 0
}

complete -o nospace -F _directory_navigator_helper_autocompletion directory-navigator-helper
