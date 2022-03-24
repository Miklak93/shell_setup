#!/bin/bash
####################################INSTRUCTIONS#################################
#Script argument: None
#####################################FUNCTIONS###################################
_get_directory_short_names() {
    echo "$(awk '{print $1}' $BASH_SCRIPTS_PATH/directory_navigator/.directory_navigator_data)"
}

_expand_short_name() {
    local directory_short_name="$1"
    echo "$(grep -wE "^$directory_short_name" $BASH_SCRIPTS_PATH/directory_navigator/.directory_navigator_data | awk '{print $2}')"
}

_get_full_path() {
    local short_name="$1"
    if [[ -z "$short_name" ]]; then
        echo "$(_get_directory_short_names)"
    elif [[ -n "$short_name" ]] && [[ -z "$2" ]]; then
        echo "$(_expand_short_name "$short_name")"
    else
        # Remove last element from array
        local expanded_short_name="$(_expand_short_name "$short_name")"
        local directory_suffix_array="${@:2}"
        local directory_suffix="${directory_suffix_array// //}"
        echo "$expanded_short_name$directory_suffix"
    fi
}

_get_possible_words() {
    local possible_words=""
    if [[ -z "$1" ]]; then
        possible_words="$(_get_directory_short_names)"
    else
        local full_path="$(_get_full_path "$@")"
        # Do not provide "." and ".." directories
        possible_words=("$(ls -A $full_path)")
    fi
    echo "${possible_words[@]}"
}

_directory_navigator_autocompletion() {
    # ${COMP_WORDS[0]} means "dn"
    local current_word="${COMP_WORDS[COMP_CWORD]}"
    # Remove current (unfinished) word from the list of arguments passed ahead
    local comp_words=("${COMP_WORDS[@]:1}")
    unset comp_words[-1]
    # Generate suggestions
    local possible_words="$(_get_possible_words "${comp_words[@]}")"
    COMPREPLY=($(compgen -W "${possible_words}" -- ${current_word}))
    return 0
}

complete -o nospace -F _directory_navigator_autocompletion dn
