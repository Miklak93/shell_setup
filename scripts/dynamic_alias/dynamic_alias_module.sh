#!/bin/bash

####################################FUNCTIONS###################################
DATA="$SCRIPTS_PATH/dynamic_alias/.dynamic_alias_data"

_get_directory_short_names() {
    echo "$(awk '{print $1}' $DATA)"
}

_expand_short_name() {
    local directory_short_name="$1"
    echo "$(grep -wE "^$directory_short_name" "$DATA" | awk '{print $2}')"
}

_build_full_path() {
    local expanded_short_name="$(eval echo $(_expand_short_name "$1"))"
    local directory_suffix_array="${@:2}"
    local directory_suffix="${directory_suffix_array// //}"
    echo "$expanded_short_name/$directory_suffix"
}

_add_to_dynamic_alias_data() {
    local directory_short_name="$1"
    local directory_full_path="$2"

    echo "$directory_short_name $directory_full_path" >> "$DATA"
}

_remove_from_dynamic_alias_data() {
    local directory_short_name="$1"
    sed -i "/${directory_short_name}/d" "$DATA"
}

_list_dynamic_alias_data() {
    cat "$DATA"
}

_dynamic_alias() {
    local request="$1"
    local dir_or_short_name="$2"

    case "${request}" in
        "add-record")
            _add_to_dynamic_alias_data "$dir_or_short_name" "$PWD/";;
        "remove-record")
            _remove_from_dynamic_alias_data "$dir_or_short_name";;
        "list-records")
            _list_dynamic_alias_data;;
        *)
            eval cd "$(_build_full_path "$@")"
    esac
}

#################################AUTOCOMPLETION#################################
_get_directory_short_names() {
    echo "$(awk '{print $1}' $DATA)"
}

_expand_short_name() {
    local directory_short_name="$1"
    echo "$(grep -wE "^$directory_short_name" "$DATA" | awk '{print $2}')"
}

_get_full_path() {
    local short_name="$1"
    if [[ -z "$short_name" ]]; then
        echo "$(_get_directory_short_names)"
    elif [[ -n "$short_name" ]] && [[ -z "$2" ]]; then
        eval echo "$(_expand_short_name "$short_name")"
    else
        # Remove last element from array
        local expanded_short_name="$(eval echo $(_expand_short_name "$short_name"))"
        local directory_suffix_array="${@:2}"
        local directory_suffix="${directory_suffix_array// //}"
        echo "$expanded_short_name/$directory_suffix"
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

_dynamic_alias_autocompletion() {
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
