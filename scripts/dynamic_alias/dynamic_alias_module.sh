#!/bin/bash

################################### CONFIG #####################################
DATA="$SHELL_SETUP_SCRIPTS_PATH/dynamic_alias/.dynamic_alias_data.sh"

################################# CORE FUNCTIONS ###############################

_get_directory_short_names() {
    awk '{print $1}' "$DATA"
}

_expand_short_name() {
    local directory_short_name="$1"
    grep -wE "^$directory_short_name" "$DATA" | awk '{print $2}'
}

_build_full_path() {
    local expanded_short_name
    expanded_short_name="$(eval echo "$(_expand_short_name "$1")")"
    shift
    local directory_suffix="${*/ /}"  # Remove spaces
    echo "$expanded_short_name/$directory_suffix"
}

_add_dynamic_alias() {
    local directory_short_name="$1"
    local directory_full_path="$2"

    if [[ -z "$directory_short_name" ]]; then
        directory_short_name=$(basename "$directory_full_path")
    fi

    echo "$directory_short_name $directory_full_path" >> "$DATA"
}

_remove_dynamic_alias() {
    local directory_short_name="$1"
    sed -i "/^${directory_short_name}[[:space:]]/d" "$DATA"
}

_get_dynamic_aliases() {
    cat "$DATA"
}

_apply_dynamic_alias() {
    local short_name="$1"
    local target_path="$(_expand_short_name "$short_name")"
    if [[ -d "$target_path" ]]; then
        cd "$target_path" || echo "Failed to change directory"
    else
        echo "dynamic_alias: Path does not exist: $target_path"
    fi
}

_dynamic_alias() {
    local request="$1"
    shift

    case "$request" in
        --add_alias)
            _add_dynamic_alias "$1" "$PWD";;
        --remove_alias)
            _remove_dynamic_alias "$1";;
        --get_aliases)
            _get_dynamic_aliases;;
        --apply_alias)
            _apply_dynamic_alias "$1";;
        *)
            local full_path="$(_build_full_path "$request" "$@")"
            if [[ -d "$full_path" ]]; then
                cd "$full_path"
            else
                echo "Invalid alias or path: $full_path"
            fi
            ;;
    esac
}

################################### AUTOCOMPLETE ###############################
_dynamic_alias_autocompletion() {
    local cur prev
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    local static_options="--add_alias --remove_alias --get_aliases --apply_alias"
    local short_names="$(_get_directory_short_names)"
    local selected_switch=""

    for word in "${COMP_WORDS[@]:1}"; do
        if [[ "$word" == --* ]]; then
            selected_switch="$word"
            break
        fi
    done

    # 🛠 Fix: if typing any dash-prefixed string, use static options
    if [[ "$cur" == "-"* ]]; then
        COMPREPLY=( $(compgen -W "$static_options" -- "$cur") )
    elif [[ -z "$selected_switch" ]]; then
        COMPREPLY=( $(compgen -W "$static_options $short_names" -- "$cur") )
    elif [[ "$selected_switch" == "--remove_alias" || "$selected_switch" == "--apply_alias" ]]; then
        COMPREPLY=( $(compgen -W "$short_names" -- "$cur") )
    else
        COMPREPLY=()
    fi
}
