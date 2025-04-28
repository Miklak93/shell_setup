#!/bin/bash
# ======================================= INSTRUCTIONS =========================================== #
# Script arguments: One of private, draft, master, main                                            #
# ================================================================================================ #

# ======================================== FUNCTIONS ============================================= #
# Helper functions
# ================================================================================================ #

# ========================================= ALIAS ================================================ #
# Define the name of the command as it appears in the shell                                        #
# ================================================================================================ #
alias git-push="python3 $SHELL_SETUP_SCRIPTS_PATH/git_push/main.py"

#===================================== AUTOCOMPLETION ============================================ #
# Enable autocompletion for the command in the shell                               #
# ================================================================================================ #
_git_push_autocompletion()
{
    COMPREPLY=()

    local current_word="${COMP_WORDS[COMP_CWORD]}"
    local possible_words="private draft master main"

    COMPREPLY=( $(compgen -W "${possible_words}" -- ${current_word}) )
    return 0
}
complete -o nospace -F _git_push_autocompletion git-push
