#!/bin/bash
# ======================================= INSTRUCTIONS =========================================== #
# Script argument: A directory path to inspect with treecat. Autocompletion works like 'cd'.
# ================================================================================================ #

# ======================================== FUNCTIONS ============================================== #
_treecat()
{
    local current_path="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
    python3 "$current_path/main.py" "$@"
}

_treecat_autocompletion()
{
    local cur="${COMP_WORDS[COMP_CWORD]}"
    COMPREPLY=( $(compgen -d -- "$cur") )
    compopt -o filenames
}

# ========================================= ALIAS ================================================= #
alias treecat="_treecat"

# =================================== AUTOCOMPLETION ============================================== #
complete -F _treecat_autocompletion treecat
