#!/bin/bash
####################################INSTRUCTIONS#################################
#Script arguments: None
####################################FUNCTIONS####################################
SHELL_SETUP_PATH="$(dirname "$(dirname "$(dirname "$(realpath "${BASH_SOURCE[0]}")")")")"
SHELL_SETUP_VIM_PATH="$SHELL_SETUP_PATH/vim"
SHELL_SETUP_SCRIPTS_PATH="$SHELL_SETUP_PATH/scripts"
SHELL_SETUP_PROFILES_PATH="$SHELL_SETUP_PATH/shell"
SHELL_SETUP_CONFIGURATION_PATH="$SHELL_SETUP_PROFILES_PATH/configuration"

_setup_link() {
    local source=$1
    local destination=$2

    # Unlink the destination if it exists
    if [ -L "$destination" ]; then
        unlink "$destination"
    fi

    # Create the symlink
    # -s creates symbolic link, -f forces it
    ln -sf "$source" "$destination"
}

_setup_links()
{
    _setup_link $SHELL_SETUP_VIM_PATH/.vim ~/.vim
    _setup_link $SHELL_SETUP_VIM_PATH/.vimrc ~/.vimrc
    _setup_link $SHELL_SETUP_PROFILES_PATH/.bashrc ~/.bashrc
    _setup_link $SHELL_SETUP_PROFILES_PATH/.inputrc ~/.inputrc
}

_setup_aliases()
{
    # Local aliases - ignored by git
    local local_aliases_path="$SHELL_SETUP_CONFIGURATION_PATH/local_aliases.sh"
    local dynamic_alias_path="$SHELL_SETUP_SCRIPTS_PATH/dynamic_alias/.dynamic_alias_data.sh"

    touch "$local_aliases_path"
    if [[ $? -ne 0 ]]; then
        return 1
    fi

    # Dynamic alias database initialization
    local content=""
    content="${content}home /home/$USER"$'\n'
    content="${content}shell_setup $SHELL_SETUP_PATH"$'\n'
    content="${content}scripts $SHELL_SETUP_SCRIPTS_PATH"$'\n'

    echo "${content}" > $dynamic_alias_path

    if [[ $? -ne 0 ]]; then
        return 1
    fi
}

_setup_files()
{
    local envvars_path="$SHELL_SETUP_CONFIGURATION_PATH/envvars.sh"

    if [[ ! -e "$envvars_path" ]]; then
        touch "$envvars_path"
    fi

    local content="SHELL_SETUP_SCRIPTS_PATH=$SHELL_SETUP_SCRIPTS_PATH"

    # Only append if the exact line doesn't already exist
    if ! grep -Fxq "$content" "$envvars_path"; then
        echo "$content" >> "$envvars_path"
    fi
}

_reset_shell()
{
    rm -rf ".shell_setup_done.sh"
    _setup_links

    _setup_files
    if [[ $? -ne 0 ]]; then
        return 1
    fi

    _setup_aliases
    if [[ $? -ne 0 ]]; then
        return 1
    fi

    touch ".shell_setup_done.sh"
    return 0
}

_setup_shell()
{
    local do_reset="Y"
    if [[ -f ".shell_setup_done.sh" ]]; then
        read -p "Shell is already setup - do you really want to reset settings? [Y\N]: " do_reset
    fi

    case "$do_reset" in
        "Y" | "y")
            _reset_shell
            echo "Done!"
            ;;
        "N" | "n")
            echo "Shell has not been reset!"
            ;;
        *)
            echo "Command not recognized!"
    esac
}
#####################################MAIN######################################
export SHELL_SETUP_SCRIPTS_PATH="${SHELL_SETUP_PATH}/scripts"

_setup_shell
