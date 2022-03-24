#!/bin/bash
####################################INSTRUCTIONS#################################
#Script arguments: Command to repeat
####################################FUNCTIONS####################################
_run_forever() {
    local result=0
    local counter=1
    local instruction="$1"

    while [[ $result -eq 0 ]]; do
        printf "\n\n*********************RUN #$counter*********************\n\n"
        let counter=counter+1
        $instruction
        result=$?
    done
}

_run_forever "$1"
