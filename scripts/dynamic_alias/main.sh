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

    local result="$(python3 "$current_path/main.py" "$@")"
    if [[ "$result" == "Command:"* ]]; then
        eval "${result#Command: }"
    elif [[ "$result" == *"Error:"* ]]; then
        printf "\033[0;31m$result"
    elif [[ "$result" == *"Success:"* ]]; then
        printf "\033[0;32m$result"
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
    # or if "-f" has not been provided - treat it as last possible argument (simplified version)
    if [[ $COMP_CWORD -gt 5 || "${COMP_WORDS[COMP_CWORD-1]}" == "-f" ]]; then
        COMPREPLY=()
    elif [[ " ${COMP_WORDS[*]} " == *" -f "* && " ${COMP_WORDS[*]} " != *" -p "* ]]; then
        COMPREPLY=( $(compgen -W "-p" -- ${current_word}) )
    # If "-p" has been provided but there is no path yet, suggest directories (like "cd" does)
    elif [[ "${COMP_WORDS[COMP_CWORD-1]}" == "-p" ]]; then
        COMPREPLY=( $(compgen -d -- "$current_word") )
    # If "-p" has been provided, but not "-f" and there is a word after -p (path is given) suggest "-f"
    elif [[ "${COMP_WORDS[*]}" =~ -p[[:space:]]+[^\ ]+ && "${COMP_WORDS[*]}" != *" -f "* ]]; then
        COMPREPLY=( $(compgen -W "-f" -- ${current_word}) )
    # Otherwise suggest both flags
    else
        COMPREPLY=( $(compgen -W "-p -f" -- ${current_word}) )
    fi
}

_get_command_autocomplete()
{
    local db="$1"
    local keys=($(_get_db_keys "$db"))
    local current_word="${COMP_WORDS[COMP_CWORD]}"

    # Suggest if we do not exceede current + 3 arguments (like "da get -n <curretn>")
    if [[ $COMP_CWORD -gt 2 ]]; then
        COMPREPLY=()
    # Otherwise suggest database keys
    else
        COMPREPLY=($(compgen -W "${keys[*]}" -- "$current_word"))
    fi
}

_use_command_autocomplete()
{
    local db="$1"
    local max_args="$2"
    # Do not change it to string!
    local keys=($(_get_db_keys "$db"))
    local current_word="${COMP_WORDS[COMP_CWORD]}"

    # Suggest if we do not exceede current + 3 (2 when no "use" is provided) arguments
    # (like "da (use) <alias> -e <current>") or when "-e" with option was not used
    if [[ "$COMP_CWORD" -gt "$((max_args))" || "${COMP_WORDS[COMP_CWORD-2]}" == "-e" ]]; then
        COMPREPLY=()
    # If "-e" flag is used suggest exe files
    elif [[ "${COMP_WORDS[COMP_CWORD-1]}" == "-e" ]]; then
        _executables_autocomplete
    elif [[ "$COMP_CWORD" -eq "$((max_args - 2))" ]]; then
        for key in "${keys[@]}"; do
            # If no key or only part of it is used suggest completion for them
            if [[ "$key" == "$current_word"* ]]; then
                COMPREPLY=($(compgen -W "-e ${keys[*]}" -- "$current_word"))
                return
            # If full key is provided switch it to its real value
            elif [[ "$current_word" == "$key"* ]]; then
                local alias_path=$(jq -r --arg k "$key" '.[$k]' "$db")
                local tail="${current_word/$key/}"
                COMPREPLY=( $(compgen -f "$alias_path$tail" -- "$current_word" ))
                return
            fi
        done
        # Having full path suggest files we may visit
        COMPREPLY=($(compgen -f -- "$current_word" ))
    # If -e has not been provided yet, suggest it
    elif [[ "$COMP_CWORD" -le "$((max_args - 1))" || "${COMP_WORDS[COMP_CWORD-1]}" != "-e" ]]; then
        COMPREPLY=($(compgen -W "-e" -- "$current_word"))
    fi
}

_dynamic_alias_autocomplete()
{
    local current_path="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
    local db="$current_path/.database.json"
    local current_word="${COMP_WORDS[COMP_CWORD]}"

    # No option has been selected so far so suggest these options
    if [[ "$COMP_CWORD" -eq 1 && -z "$current_word" ]]; then
        local static_options=("add" "delete" "get" "use")
        local keys=($(_get_db_keys "$db"))
        COMPREPLY=($(compgen -W "${keys[*]} ${static_options[*]}" -- "$current_word"))
        return 0
    fi

    case "${COMP_WORDS[1]}" in
        "add")
            _add_command_autocomplete
            ;;
        "delete" | "get")
            _get_command_autocomplete "$db"
            ;;
        "use")
            _use_command_autocomplete "$db" 4
            ;;
        *)
            _use_command_autocomplete "$db" 3
        esac
}

# ========================================= ALIAS ================================================ #
# Define the name of the command as it appears in the shell                                        #
# ================================================================================================ #
alias da='_dynamic_alias'

#===================================== AUTOCOMPLETION ============================================ #
# Enable autocompletion for the command in the shell                                               #
# ================================================================================================ #
complete -o nospace -F _dynamic_alias_autocomplete da
