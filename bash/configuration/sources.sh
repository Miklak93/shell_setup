_source_main_scripts()
{
    for directory in "$SCRIPTS_PATH"/*; do
        if [[ -d "$directory" && -f "$directory/main.sh" ]]; then
            source "$directory/main.sh"
        fi
    done
}

_source_main_scripts