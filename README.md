Instruction:

At the beginning install git, vim, gnome-tweaks, gnome-shell-extensions, gnome-shell-extension-prefs

I. General apperance
   1. Type "Tweaks" in activities, go to "Apperance" tab and do:
      i.   Applications: Yaru-dark
      ii.  Cursor: DMZ-BLACK
      iii. Icons: Yaru
   2. Type "Settings" in activities, go to "Dock" under "Apperance" tab and do:
      i.  Position on screen: "Bottom"
      ii. Icon size: "24"
   3. In order to remove "Home" from Desktop type "Extensions" in activities and disable "Desktop Icons"
   4. In order to merge "Activities" tab with "Dock" panel perform
      sudo apt install gnome-shell-extension-dash-to-panel
      After that log out, go to "Gome tweaks", click "Extensions" in the left and then
      select "Dash to panel"

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
  Also if vim "V" + "+" does not work install vim-gtk.

  Clone this repository to /repo/$USER and evaluate setup_shell.sh
  from scripts.
