#!/bin/bash

###################################INSTRUCTIONS#################################
# Script arguments: One of private, draft, master, main
################################################################################

# Source the module
source "$SHELL_SETUP_SCRIPTS_PATH/git_push/git_push_module.sh"

# Define the alias
alias git-push='_git_push'

# Setup autocompletion
complete -o nospace -F _git_push_autocompletion git-push
