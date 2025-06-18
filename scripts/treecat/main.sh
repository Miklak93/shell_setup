#!/bin/bash
# ======================================= INSTRUCTIONS =========================================== #
# Script argument: Name of the directory whose files you want to inspect with treecat.
# This script will tab-complete available directories.
# ================================================================================================ #

# ======================================== FUNCTIONS ============================================== #
# Helper functions
# ================================================================================================ #
_treecat()
{
    local current_path="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
    python3 "$current_path/main.py" "$1"
}

_treecat_autocompletion()
{
    local current_word="${COMP_WORDS[COMP_CWORD]}"
    local dir_list=". .."

    for dir in */; do
        [[ -d "$dir" ]] && dir_list="$dir_list ${dir%/}"
    done

    COMPREPLY=( $(compgen -W "$dir_list" -- "$current_word") )
}

# ========================================= ALIAS ================================================= #
# Define the alias command name
# ================================================================================================ #
alias treecat="_treecat"

# =================================== AUTOCOMPLETION ============================================== #
# Enable autocompletion for the alias
# ================================================================================================ #
complete -o default -F _treecat_autocompletion treecat
