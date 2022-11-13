#!/bin/bash
####################################INSTRUCTIONS#################################
#Script arguments: None
####################################FUNCTIONS####################################
_create_confirmation_file()
{
    touch ".shell_setup_done"
}

_create_links()
{
    ln -s /repo/$USER/shell_setup/vim/.vim /home/$USER/.vim
    ln -s /repo/$USER/shell_setup/vim/.vimrc /home/$USER/.vimrc
    ln -s /repo/$USER/shell_setup/bash/.bashrc /home/$USER/.bashrc
    ln -s /repo/$USER/shell_setup/bash/.inputrc /home/$USER/.inputrc
}

_create_files()
{
    touch /repo/$USER/shell_setup/bash/bashrc/local_aliases.sh
}

_has_been_reset()
{
    if [[ -f ".shell_setup_done" ]]; then
        return 1
    fi
    return 0
}

_remove_links()
{
    rm -f  /home/$USER/.bashrc
    rm -f  /home/$USER/.inputrc
    rm -rf /home/$USER/.vim
    rm -rf /home/$USER/.vimrc
}

_reset_shell()
{
    local do_reset="Y"
    _has_been_reset
    if [[ $? == 1 ]]; then
        echo "Shell setup was done earlier!"
        read -p "Do you want to reset settings? [Y\N]: " do_reset
        echo ""
    fi
    case "$do_reset" in
        "Y" | "y")
            _remove_links
            _create_links
            _create_files
            _create_confirmation_file
            echo "Done"
            ;;
        "N" | "n")
            echo "Shell has not been reset!"
            ;;
        *)
            echo "Command not recognized!"
    esac
}
#####################################MAIN######################################
_reset_shell
