#!/bin/bash

################################### CONFIG #####################################
# Database path
DATA_PATH="$SHELL_SETUP_SCRIPTS_PATH/dynamic_alias/.dynamic_alias_data.sh"

# Commands
ADD_COMMAND="--add_alias"
APPLY_COMMAND="--apply_alias"
DELETE_COMMAND="--delete_alias"
GET_COMMAND="--get_aliases"

ALL_COMMANDS=("$ADD_COMMAND" "$APPLY_COMMAND" "$DELETE_COMMAND" "$GET_COMMAND")
DYNAMIC_COMMANDS=("$ADD_COMMAND" "$APPLY_COMMAND" "$DELETE_COMMAND")

# Default values
TRUE="true"
FALSE="false"

CD_EXECUTABLE="cd"
CAT_EXECUTABLE="cat"
EXECUTABLES_PATH="/usr/bin"

ERROR="Error dn"
SUCCESS="Success dn"

################################# CORE FUNCTIONS ###############################
_parse_args()
{
    if [[ "$1" == --* ]] && [[ $(_is_any_of "$1" "${ALL_COMMANDS[@]}") == "$FALSE" ]]; then
        echo "$ERROR: Unknown command: $1." >&2
        return
    fi

    case "$#" in
        0)
            echo "$ERROR: No arguments provided." >&2
            ;;
        1)
            if [[ "$(_is_any_of "$1" "${DYNAMIC_COMMANDS[@]}")" == "$TRUE" ]]; then
                echo "$ERROR: Cannot execute with command '$1' only. You need to provide an alias - see 'dn $GET_COMMAND'." >&2
            elif [[ "$1" == "$GET_COMMAND" ]]; then
                echo "$GET_COMMAND $CAT_EXECUTABLE"
            else
                echo "$APPLY_COMMAND $1 $CD_EXECUTABLE"
            fi
            ;;
        2)
            if [[ "$(_is_any_of "$1" "${ALL_COMMANDS[@]}")" == "$TRUE" ]]; then
                if [[ "$1" == "$ADD_COMMAND" ]]; then
                    echo "$ADD_COMMAND $2"
                elif [[ "$1" == "$GET_COMMAND" ]]; then
                    echo "$GET_COMMAND $2"
                else
                    echo "$1 $2 $CD_EXECUTABLE"
                fi
            else
                echo "$APPLY_COMMAND $1 $2"
            fi
            ;;
        3)
            if [[ "$(_is_any_of "$1" "${DYNAMIC_COMMANDS[@]}")" == "$TRUE" ]]; then
                echo "$1 $2 $3"
            elif [[ "$1" == "$GET_COMMAND" ]]; then
                echo "$ERROR: $GET_COMMAND cannot have three arguments."
            else
                echo "$ERROR: Unknown command: $1." >&2
            fi
            ;;
        *)
            echo "$ERROR: $# arguments passed: $@."
            ;;
    esac
}

_is_any_of()
{
    local value="$1"
    local options="${@:2}"

    if [[ " ${options[*]} " == *" $value "* ]]; then
        echo "$TRUE"
    else
        echo "$FALSE"
    fi
}

_db_find()
{
    local key="$1"
    local value="$(grep -wE "^$key" "$DATA_PATH" | awk '{print $2}')"

    if [[ -z "$value" ]]; then
        echo "$ERROR: There is no such key '$key' in the database."
    else
        echo "$value"
    fi
}

_db_keys()
{
    cat "$DATA_PATH" | awk '{print $1}'
}

_add_alias()
{
    # Target may be simply the alias or full path - in such a case basename will be taken (i.e. target = /path/to/dir => alias = dir)
    local target="$1"
    local full_path="$2"
    local alias="$(basename "$target")"

    # If full_path is not provided, determine if it is valid file, directory or alias
    if [[ -z "$full_path" ]]; then
        # Valid file, directory or symlink
        if [[ -e "$target" ]]; then
            full_path="$target"
        # Alias, so use current directory
        else
            full_path="$(pwd)"
        fi
    else
        if [[ ! -e "$full_path" ]]; then
            echo "$ERROR: '$full_path' no such file or directory."
            return 1
        fi
    fi

    local alias_path="$(realpath "$full_path")"
    echo "$alias $alias_path" >> "$DATA_PATH"
    echo "$SUCCESS: Entry {$alias => $alias_path} successfully added."
}

_apply_alias()
{
    # May be simply alias or alias/path/to/something
    local target="$1"
    local executable="$2"

    local space_separated_target=$(echo "$target" | sed 's#\/# #g')
    local alias="$(echo "$space_separated_target" | awk '{print $1}' )"

    # Special case: if the $target starts with '/' keep leading '/'
    if [[ "$target" == /* ]]; then
        alias="/$alias"
    fi

    local alias_path="$(_db_find "$alias")"
    if [[ "$alias_path" == "$ERROR"* ]]; then
        echo "$alias_path" >&2
        return 1
    fi

    local tail="$(echo "$space_separated_target" | awk '{ $1=""; print substr($0,2) }' | sed 's# #\/'#g)"
    if [[ -z "$tail" ]]; then
        $executable "$alias_path"
    else
        $executable "$alias_path/$tail"
    fi
}

_delete_alias()
{
    local alias="$1"
    local alias_path="$(_db_find "$alias")"
    if [[ "$alias_path" == "$ERROR"* ]]; then
        echo "$alias_path" >&2
        return 1
    fi

    sed -i "/^${alias}[[:space:]]/d" "$DATA_PATH"
    echo "$SUCCESS: Entry {$alias => $alias_path} successfully removed."
}

_get_aliases()
{
    local executable="$1"
    $executable "$DATA_PATH"
}

_execute()
{
    local command="$1"
    case "$command" in
        "$ADD_COMMAND")
            _add_alias "$2" "$3"
            ;;
        "$APPLY_COMMAND")
            _apply_alias "$2" "$3"
            ;;
        "$DELETE_COMMAND")
            _delete_alias "$2"
            ;;
        "$GET_COMMAND")
            _get_aliases "$2"
            ;;
        *)
            echo "$ERROR: Unknown command: $command." >&2
            ;;
    esac
}

_dynamic_alias()
{
    local args="$(_parse_args "$@")"
    if [[ "$args" == "$ERROR"* ]]; then
        echo "$args" >&2
    else
        _execute $args
    fi
}

################################### AUTOCOMPLETE ###############################
_get_options()
{
    local command="$1"
    local current_word="$2"

    case "$command" in
        "$ADD_COMMAND")
            COMPREPLY=()
            ;;
        "$APPLY_COMMAND" | "$DELETE_COMMAND")
            COMPREPLY=($(compgen -W "$(_db_keys)" -- $current_word))
            ;;
        # $GET_COMMAND or alias is used
        *)
            # Only perform completion if the current word is not empty
            if [[ -n "$current_word" ]]; then
                COMPREPLY=( $(compgen -c "$current_word" "$EXECUTABLES_PATH") )
            else
                # If nothing is typed, do not perform any search (speed up)
                COMPREPLY=()
            fi
            ;;
    esac
}

_dynamic_alias_autocompletion()
{
    local possible_options=("${ALL_COMMANDS[@]}" $(_db_keys))

    local current_word="${COMP_WORDS[COMP_CWORD]}"
    local previous_word="${COMP_WORDS[COMP_CWORD-1]}"
    local second_to_last_word="${COMP_WORDS[COMP_CWORD-2]}"

    # The special case and the only one with three arguments
    if [[ "${second_to_last_word}" == "$APPLY_COMMAND" ]]; then
        # Pass alias and already typing word
        _get_options "$previous_word" "$current_word"
    elif [[ " ${possible_options[*]} " == *" $previous_word "* ]]; then
        _get_options "$previous_word" "$current_word"
    else
        # Get all options
        COMPREPLY=($(compgen -W "${possible_options[*]}" -- "$current_word"))
    fi
}
