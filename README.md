Before you start make sure that you have installed git, vim
and /repo/$USER catalogue exists.

sudo chmod ugo+rw /repo/$USER                                                                                                                
git clone https://github.com/Miklak93/shell_setup.git                           
sudo rm -f /home/$USER/.bashrc                                                  
sudo rm -rf /home/$USER/.vim                                                    
sudo ln -s /repo/$USER/shell_setup/vim/.vim /home/$USER/.vim                                
sudo ln -s /repo/$USER/shell_setup/vim/.vimrc /home/$USER/.vimrc                            
sudo ln -s /repo/user/shell_setup/bash/.bashrc /home/$USER/.bashrc 
