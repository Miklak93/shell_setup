Instruction:

I. General apperance
   1. Install "Yaru-dark" theme suitable for your Ubuntu release
   2. Type "Tweaks" in activities, go to "Apperance" tab and do:
      i.   Applications: Yaru-dark
      ii.  Cursor: DMZ-BLACK
      iii. Icons: Yaru
   3. Type "Settings" in activities, go to "Dock" tab and do:
      i.  Position on screen: "Bottom"
      ii. Icon size: "24"

II. Terminal apperance
   1. Open terminal, click Edit -> Preferences and do:
      i.  Colors: "Custom" with:
          a. Default color: #ADA4A4, #000000
          b. Check "Use transparency from system theme"
      ii. Scrolling: uncheck "Limit scrollback"

III. Shell setup
  REMARK:
  Before you start make sure that you have installed git, vim
  and /repo/$USER catalogue exists with write and read priviledges.
  
  cd /repo/$USER
  git clone https://github.com/Miklak93/shell_setup.git
  rm -f /home/$USER/.bashrc
  rm -rf /home/$USER/.vim
  ln -s /repo/$USER/shell_setup/vim/.vim /home/$USER/.vim
  ln -s /repo/$USER/shell_setup/vim/.vimrc /home/$USER/.vimrc
  ln -s /repo/user/shell_setup/bash/.bashrc /home/$USER/.bashrc
