#!/bin/bash
####################################INSTRUCTIONS#################################
#Script arguments: None
####################################FUNCTIONS####################################
rm -f /home/$USER/.bashrc
rm -rf /home/$USER/.vim
ln -s /repo/$USER/shell_setup/vim/.vim /home/$USER/.vim
ln -s /repo/$USER/shell_setup/vim/.vimrc /home/$USER/.vimrc
ln -s /repo/$USER/shell_setup/bash/.bashrc /home/$USER/.bashrc
