#!/bin/bash
# ======================================= INSTRUCTIONS =========================================== #
# Script arguments: Short directory name saved in directory navigator dababase.
# ================================================================================================ #

# ========================================= CONFIG ==========================================+==== #
# Configuration variables
# ================================================================================================ #

# ======================================== FUNCTIONS ============================================= #
# Helper functions
# ================================================================================================ #
_dynamic_alias()
{
    local current_path="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
    local db="$current_path/.database.json"

    if [[ ! -f "$db" ]]; then
        echo "{}" > "$db"
    fi

    local result="$(python3 "$current_path/main.py" "$@")"
    if [[ "$result" == "Command:"* ]]; then
        eval "${result#Command: }"
    elif [[ "$result" == *"Error:"* ]]; then
        printf "\033[0;31m$result"
    else
        echo "$result"
    fi
}

_get_db_keys()
{
    local db="$1"
    jq -r 'keys[]' "$db" 2>/dev/null
}

_executables_autocomplete()
{
    local current_word="${COMP_WORDS[COMP_CWORD]}"

    # If something was provided, suggest matching executables
    if [[ "$current_word" ]]; then
        COMPREPLY=( $(compgen -c -- "$current_word") )
    else
    # Nothing typed so no suggestions (otherwise shell is stuck because of searching binaries)
        COMPREPLY=()
    fi
}

_add_command_autocomplete()
{
    local current_word="${COMP_WORDS[COMP_CWORD]}"

    # Suggest if we do not exceede current + 5 arguments (like "da add <alias> -p <path> -f")
    if [[ $COMP_CWORD -gt 5 ]]; then
        COMPREPLY=()
    # If nothing has been provided, suggest "-p" and "-f"
    elif [[ "${COMP_WORDS[COMP_CWORD-1]}" == "add" ]]; then
        COMPREPLY=( $(compgen -W "-p -f" -- ${current_word}) )
    # If "-f" has been provided, but not "-p" suggest "-f"
    elif [[ " ${COMP_WORDS[*]} " == *" -f "* && " ${COMP_WORDS[*]} " != *" -p "* ]]; then
        COMPREPLY=( $(compgen -W "-p" -- ${current_word}) )
    # If "-p" has been provided, but not "-f" and there is a word after -p (path is given) suggest "-f"
    elif [[ "${COMP_WORDS[*]}" =~ -p[[:space:]]+[^\ ]+ && "${COMP_WORDS[*]}" != *" -f "* ]]; then
        COMPREPLY=( $(compgen -W "-f" -- ${current_word}) )
    fi
}

_get_command_autocomplete()
{
    local keys=("$@")
    local current_word="${COMP_WORDS[COMP_CWORD]}"

    # Suggest if we do not exceede current + 3 arguments (like "da get -n <curretn>")
    if [[ $COMP_CWORD -gt 2 ]]; then
        COMPREPLY=()
    # Otherwise suggest database keys
    else
        COMPREPLY=($(compgen -W "-n --name ${keys[*]}" -- "$current_word"))
    fi
}

_list_command_autocomplete()
{
    local keys=("$@")
    local current_word="${COMP_WORDS[COMP_CWORD]}"

    # Suggest if we do not exceede current + 3 arguments (like "da list -e <current>")
    if [[ $COMP_CWORD -gt 3 ]]; then
        COMREPLY=()
    # If "-e" flag is used suggest exe files
    elif [[ "${COMP_WORDS[2]}" == "-e" ]]; then
        _executables_autocomplete
    # If "list" is last word suggest "-e"
    elif [[ "${COMP_WORDS[1]}" == "list" ]]; then
        COMPREPLY=( $(compgen -W "-e" -- ${current_word}) )
    fi
}

_use_command_autocomplete()
{
    local args=("$@")
    local command_or_alias="${args[0]}"
    local keys=("${args[@]:1}")
    local current_word="${COMP_WORDS[COMP_CWORD]}"

    echo "1"
    # Suggest if we do not exceede current + 4 arguments (like "da use <alias> -e <current>")
    if [[ $COMP_CWORD -gt 4 ]]; then
        COMPREPLY=()
    # If "use" command was provided and nothing more suggest keys
    elif [[ "$command_or_alias" == "use" && "${COMP_WORDS[CWORD-1]}" == "use" ]]; then
        COMPREPLY=($(compgen -W "-e ${keys[*]}" -- "$current_word"))
    # If "-e" was provided suggest executables
    elif [[ "${COMP_WORDS[COMP_CWORD-1]}" == "-e" ]]; then
        _executables_autocomplete
    fi
}

_dynamic_alias_autocomplete()
{
    local current_path="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
    local db="$current_path/.database.json"

    local static_options=("add" "delete" "get" "list" "use")
    local db_keys=("$(_get_db_keys "$db")")
    local all_options=("${static_options[@]}" "${db_keys[@]}")

    local current_word="${COMP_WORDS[COMP_CWORD]}"

    # No option has been selected so far
    if [[ "${COMP_WORDS[COMP_CWORD-1]}" == "da" ]]; then
        COMPREPLY=($(compgen -W "${all_options[*]}" -- "$current_word"))
    # Option has been selected
    elif [[ "${COMP_WORDS[1]}" == "add" ]]; then
        _add_command_autocomplete
    elif [[ "${COMP_WORDS[1]}" == "delete" || "${COMP_WORDS[1]}" == "get" ]]; then
        _get_command_autocomplete "${db_keys[@]}"
    elif [[ "${COMP_WORDS[1]}" == "list" ]]; then
        _list_command_autocomplete "${db_keys[@]}"
    elif [[ "${COMP_WORDS[1]}" == "use" || " ${db_keys[*]} " == *" ${COMP_WORDS[1]} "* ]]; then
        _use_command_autocomplete "${db_keys}[@]}"
    fi
}

# ========================================= ALIAS ================================================ #
# Define the name of the command as it appears in the shell                                        #
# ================================================================================================ #
alias da='_dynamic_alias'

#===================================== AUTOCOMPLETION ============================================ #
# Enable autocompletion for the command in the shell                                               #
# ================================================================================================ #
complete -o nospace -F _dynamic_alias_autocomplete da
