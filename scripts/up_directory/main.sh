#!/bin/bash
# ======================================= INSTRUCTIONS =========================================== #
# Script arguments: One of private, draft, master, main                                            #
# ================================================================================================ #

# ======================================== FUNCTIONS ============================================= #
# Helper functions
# ================================================================================================ #
_up_directory()
{
    directory="$(python3 $SHELL_SETUP_SCRIPTS_PATH/up_directory/main.py "$1")"
    if [[ "$directory" == "Error"* ]]; then
        printf "\033[0;31m$directory"
    else
        cd "$directory"
    fi
}

# ========================================= ALIAS ================================================ #
# Define the name of the command as it appears in the shell                                        #
# ================================================================================================ #
alias upd="_up_directory"

#===================================== AUTOCOMPLETION ============================================ #
# Enable autocompletion for the command in the shell                               #
# ================================================================================================ #
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
complete -o nospace -F _up_directory_autocompletion upd
