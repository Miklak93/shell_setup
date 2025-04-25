_source_main_scripts()
{
    for directory in "$SHELL_SETUP_SCRIPTS_PATH"/*; do
        if [[ -d "$directory" && -f "$directory/main.sh" ]]; then
            source "$directory/main.sh"
        fi
    done
}

_source_main_scripts