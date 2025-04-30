#!/bin/bash
# ======================================= INSTRUCTIONS =========================================== #
# Script argument: Name of directory where you wish to go. Script will use
# backward counting, when your argument will be name of directory.
# ================================================================================================ #

# ========================================= CONFIG ==========================================+==== #
# Configuration variables
# ================================================================================================ #

# ======================================== FUNCTIONS ============================================= #
# Helper functions
# ================================================================================================ #
_up_directory()
{
    local current_path="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
    local directory="$(python3 $current_path/main.py "$1")"
    if [[ "$directory" == "Error"* ]]; then
        printf "\033[0;31m$directory"
    else
        cd "$directory"
    fi
}

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

# ========================================= ALIAS ================================================ #
# Define the name of the command as it appears in the shell                                        #
# ================================================================================================ #
alias upd="_up_directory"

#===================================== AUTOCOMPLETION ============================================ #
# Enable autocompletion for the command in the shell                                               #
# ================================================================================================ #
complete -o nospace -F _up_directory_autocompletion upd
