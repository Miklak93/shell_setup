#!/bin/bash
####################################INSTRUCTIONS#################################
#Script arguments: Name of program
####################################FUNCTIONS####################################
_build_command()
{
    local option="$1"
    local command="$2"
    local time_measure="$3"
    local time_value="$4"
    local to_eval=""

    if [[ ${option} =~ "script" ]]; then
        to_eval="./${command}"
    else
        to_eval="${command}"
    fi

    if [[ "seconds" =~ ${time_measure} ]]; then
        to_eval="sleep ${time_value}; ${to_eval}"
        echo "gnome-terminal -- /bin/bash -c \"${to_eval}; exec bash\""
    else
        echo "echo \"gnome-terminal -- /bin/bash -c \\\"${to_eval}; exec bash\\\"\""
    fi
}

_detect_option()
{
    local command="$1"
    if [[ ${command} == *.sh ]]; then
        echo "script"
    else
        echo "command"
    fi
}

_set_timer()
{
    local time_measure="$1"
    local time_value="$2"
    local to_eval=""

    if [[ "seconds" =~ ${time_measure} ]]; then
        to_eval="at now"
    else
        to_eval="at ${time_value} ${time_measure}"
    fi

    echo "${to_eval}"
}

_run_after()
{
    local command="$1"
    local time_value="$2"
    local time_measure="$3"
    local option="$(_detect_option ${command})"

    local timer="$(_set_timer ${time_measure} ${time_value})"
    local to_eval="$(_build_command ${option} "${command}" ${time_measure} ${time_value})"

    eval ""${to_eval}" | "${timer}""
}
#################################################################################
_run_after "$@"
