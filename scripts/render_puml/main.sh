#!/bin/bash
# ======================================= INSTRUCTIONS =========================================== #
# Script arguments: One of private, draft, master, main                                            #
# ================================================================================================ #

# ========================================= CONFIG ==========================================+==== #
# Configuration variables
# ================================================================================================ #

# ======================================== FUNCTIONS ============================================= #
# Helper functions
# ================================================================================================ #
_render_puml_autocompletion()
{
    COMPREPLY=()
    local options="-i --input -o --output -v --verbose"
    local current="${COMP_WORDS[COMP_CWORD]}"
    local previous="${COMP_WORDS[COMP_CWORD-1]}"

    # 1. If previous was -i or -o, suggest files/paths
    if [[ "$previous" == "-i" || "$previous" == "-o" || "$previous" == "--input" || "$previous" == "--output" ]]; then
        COMPREPLY=( $(compgen -f -- "$current") )
        return 0
    fi

    # 2. Otherwise, suggest options
    COMPREPLY=( $(compgen -W "${options}" -- "$current") )
    return 0
}

# ========================================= ALIAS ================================================ #
# Define the name of the command as it appears in the shell                                        #
# ================================================================================================ #
alias render-puml="python3 "$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"/main.py"

#===================================== AUTOCOMPLETION ============================================ #
# Enable autocompletion for the command in the shell                                               #
# ================================================================================================ #
complete -o nospace -F _render_puml_autocompletion render-puml