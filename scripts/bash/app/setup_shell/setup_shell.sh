#!/bin/bash
####################################INSTRUCTIONS#################################
#Script arguments: None
####################################FUNCTIONS####################################
cd /repo/$USER
git clone https://github.com/Miklak93/shell_setup.git
rm -f /home/$USER/.bashrc
rm -rf /home/$USER/.vim
ln -s /repo/$USER/shell_setup/vim/.vim /home/$USER/.vim
ln -s /repo/$USER/shell_setup/vim/.vimrc /home/$USER/.vimrc
ln -s /repo/$USER/shell_setup/bash/.bashrc /home/$USER/.bashrc
