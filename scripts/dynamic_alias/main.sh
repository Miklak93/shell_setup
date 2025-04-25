#!/bin/bash

###################################INSTRUCTIONS#################################
# Script arguments: Short directory name saved in directory navigator dababase.
################################################################################

# Source the module
source "$SCRIPTS_PATH/dynamic_alias/dynamic_alias_module.sh"

# Create the alias
alias da='_dynamic_alias'

# Setup autocompletion
complete -o nospace -F _dynamic_alias_autocompletion da
