#!/bin/bash
####################################INSTRUCTIONS#################################
#Script arguments: None
####################################FUNCTIONS####################################
SHELL_SETUP_PATH="$(dirname "$(dirname "$(dirname "$(realpath "${BASH_SOURCE[0]}")")")")"

_setup_link() {
    local source=$1
    local destination=$2

    # Unlink the destination if it exists
    if [ -L "$destination" ]; then
        echo "Unlinking existing symlink: $destination"
        unlink "$destination"
    fi

    # Create the symlink
    # -s creates symbolic link, -f forces it
    echo "Creating symlink: $destination -> $source"
    ln -sf "$source" "$destination"
}

_setup_links()
{
    _setup_link $SHELL_SETUP_PATH/vim/.vim ~/.vim
    _setup_link $SHELL_SETUP_PATH/vim/.vimrc ~/.vimrc
    _setup_link $SHELL_SETUP_PATH/shell/.bashrc ~/.bashrc
    _setup_link $SHELL_SETUP_PATH/shell/.inputrc ~/.inputrc
}

_setup_files()
{
    # Local aliases - ignored by git
    local local_aliases_path="$SHELL_SETUP_PATH/shell/configuration/local_aliases.sh"
    local dynamic_alias_path="$SHELL_SETUP_PATH/scripts/dynamic_alias/.dynamic_alias_data.sh"

    touch "$local_aliases_path"

    if [[ $? -ne 0 ]]; then
        return 1
    fi

    # Dynamic alias initial data
    local content=""
    content="${content}home /home/$USER"$'\n'
    content="${content}shell_setup $SHELL_SETUP_PATH"$'\n'
    content="${content}vim $SHELL_SETUP_PATH/shell_setup/vim"$'\n'

    echo "${content}" > $dynamic_alias_path

    if [[ $? -ne 0 ]]; then
        return 1
    fi
}

_reset_shell()
{
    rm -rf ".shell_setup_done.sh"
    _setup_links
    result=$(_setup_files)
    if [[ -n "$result" ]]; then
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
_setup_shell
