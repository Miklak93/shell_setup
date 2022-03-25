#!/bin/bash
###################################INSTRUCTIONS#################################
# Script arguments: Short directory name saved in directory navigator dababase.
####################################FUNCTIONS###################################
_get_directory_short_names() {
    echo "$(awk '{print $1}' $BASH_SCRIPTS_PATH/directory_navigator/.directory_navigator_data)"
}

_expand_short_name() {
    local directory_short_name="$1"
    echo "$(grep -wE "^$directory_short_name" $BASH_SCRIPTS_PATH/directory_navigator/.directory_navigator_data | awk '{print $2}')"
}

_build_full_path() {
    local expanded_short_name="$(eval echo $(_expand_short_name "$1"))"
    local directory_suffix_array="${@:2}"
    local directory_suffix="${directory_suffix_array// //}"
    echo "$expanded_short_name/$directory_suffix"
}

_add_to_directory_navigator_data() {
    local directory_short_name="$1"
    local directory_full_path="$2"

    echo "$directory_short_name $directory_full_path" >> "$BASH_SCRIPTS_PATH/directory_navigator/.directory_navigator_data"
}

_remove_from_directory_navigator_data() {
    local directory_short_name="$1"
    sed -i "/${directory_short_name}/d" $BASH_SCRIPTS_PATH/directory_navigator/.directory_navigator_data
}

_list_directory_navigator_data() {
    cat "$BASH_SCRIPTS_PATH/directory_navigator/.directory_navigator_data"
}

_run_directory_navigator() {
    local request="$1"
    local dir_or_short_name="$2"

    case "${request}" in
        "add-record")
            _add_to_directory_navigator_data "$dir_or_short_name" "$PWD/";;
        "remove-record")
            _remove_from_directory_navigator_data "$dir_or_short_name";;
        "list-records")
            _list_directory_navigator_data;;
        *)
            eval cd "$(_build_full_path "$@")"
    esac
}

######################################MAIN######################################
_run_directory_navigator "$@"
