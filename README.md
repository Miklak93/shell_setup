<p align="center">Instructions</p></br>
At the beginning install git, vim, gnome-tweaks, gnome-shell-extensions, xrdp.<br /><br />
##General apperance:
<space><space>*<space>Type "Tweaks" in activities, go to "Apperance" tab and do:<br />
      i.   Applications: Yaru-dark<br />
      ii.  Cursor: DMZ-BLACK<br />
      iii. Icons: Yaru<br />
   2. Type "Settings" in activities, go to "Dock" under "Apperance" tab and do:
      i.  Position on screen: "Bottom"<br />
      ii. Icon size: "24"<br />
   3. In order to remove "Home" from Desktop type "Extensions" in activities and disable "Desktop Icons"<br />
   4. In order to merge "Activities" tab with "Dock" panel perform<br /><br />
      sudo apt install gnome-shell-extension-dash-to-panel<br />
      After that log out, go to "Gome tweaks", click "Extensions" in the left and then<br />
      select "Dash to panel"<br /><br />
II. Terminal apperance
   1. Open terminal, click Edit -> Preferences and do:<br />
      i.  Colors: "Custom" with:<br />
          a. Default color: #ADA4A4, #000000<br />
          b. Check "Use transparency from system theme"<br />
      ii. Scrolling: uncheck "Limit scrollback"<br /><br />
III. Shell setup<br />
   REMARK:<br />
   Before you start make sure that you have installed git, vim<br />
   and /repo/$USER catalogue exists with write and read priviledges.<br />
   Also if vim "V" + "+" does not work install vim-gtk.<br /><br />
IV. Remote connection<br />
    Since you have installed xrdp go to /etc/xrdp/startwm.sh script and paste the following list just under the beginning<br />
    script comment:<br /><br />
    sudo sed -i '4 i\export XDG_CURRENT_DESKTOP=ubuntu:GNOME' /etc/xrdp/startwm.sh<br />
    sudo sed -i '4 i\export GNOME_SHELL_SESSION_MODE=ubuntu' /etc/xrdp/startwm.sh<br />
    sudo sed -i '4 i\export DESKTOP_SESSION=ubuntu' /etc/xrdp/startwm.sh<br />


  Clone this repository to /repo/$USER and evaluate setup_shell.sh
  from scripts.
