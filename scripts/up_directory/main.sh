#!/bin/bash

###################################INSTRUCTIONS#################################
# Script argument: Name of directory where you wish to go. Script will use
# backward counting, when your argument will be name of directory.
################################################################################

# Source the module
source "$SCRIPTS_PATH/up_directory/up_directory_module.sh"

# Create the alias
alias upd='_up_directory'

# Setup autocompletion
complete -o nospace -F _up_directory_autocompletion upd
