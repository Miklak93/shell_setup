#!/bin/bash
####################################INSTRUCTIONS#################################
#Script arguments: Name of terminal tab
####################################FUNCTIONS####################################
_name_prompt() {
    _prompt_name="\033]0;$1\a"
    PROMPT_COMMAND='echo -en "$_prompt_name"'
}
#################################################################################
_name_prompt "$1"
