_source_all_files_from_dir() {
    for script in "$1"/*; do
        source "$script"
    done
}

_source_all_files_from_dir "$BASH_AUTOCOMPLETION_PATH"

# Disable ctrl + 1 ssty signal sent to have block text matching in vim
stty start undef
