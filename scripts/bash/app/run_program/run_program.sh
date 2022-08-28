#!/bin/bash
####################################INSTRUCTIONS#################################
#Script arguments: Name of program
####################################FUNCTIONS####################################
_run_program () {
    local program_name="$1"
    eval "$1"
}

_run_program () {
    program_name=$(zenity --entry --title "Program name" --text "Program")
    eval ${program_name}
}
#################################################################################
_run_program
