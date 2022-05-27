<div align="center">
      INSTRUCTIONS
</div>

-----------------

## Preliminaries: 
Start with installing **git**, **vim**, **gnome-tweaks**, **gnome-shell-extensions**, **dconf-editor**, **xrdp**.<br /><br />

## General apperance:
* Type **Tweaks** in **Activities**, go to **Apperance** tab and set up
  * Applications: *Yaru*
  * Cursor: *DMZ-BLACK*
  * Icons: *Yaru*
* Type **Settings** in* **Activities**, go to **Dock** under **Apperance** tab and set up
  * Position on screen: *Bottom*
  * Icon size: *24*
* In order to remove **Home** from Desktop type **Extensions** in **Activities** and disable *Desktop Icons*
* In order to merge **Activities** tab with **Dock** panel perform

      sudo apt install gnome-shell-extension-dash-to-panel
      
  After that log out, go to **Gome tweaks**, click **Extensions\** in the left and then
  select *Dash to panel*.
* In order to disable logoff prompt
  * Type **dconf** in **Activities*
  * Move through **org** -> **gnome** -> **gnome-session**
  * Disable *Logout prompt*

## Terminal apperance
* Open terminal, click "Edit", then "Preferences" and select
   * Text: Uncheck "Terminal bell" 
   * Colors: "Custom" with:
      * Default color: #ADA4A4, #000000
      * Check "Use transparency from system theme"
   * Scrolling: uncheck "Limit scrollback"

## Shell setup
   **REMARK: Before you start make sure that you have installed git, vim
   and /repo/$USER catalogue exists with write and read priviledges.**<br/>
   Also install **vim-gtk** if vim "V" + "+" does not work
   
## Remote connection
   Since you have installed xrdp go to /etc/xrdp/startwm.sh script and paste the following list just under the beginning
   script comment
   
    sudo sed -i '4 i\export XDG_CURRENT_DESKTOP=ubuntu:GNOME' /etc/xrdp/startwm.sh
    sudo sed -i '4 i\export GNOME_SHELL_SESSION_MODE=ubuntu' /etc/xrdp/startwm.sh
    sudo sed -i '4 i\export DESKTOP_SESSION=ubuntu' /etc/xrdp/startwm.sh

  Finally, clone this repository to /repo/$USER and evaluate setup_shell.sh from scripts.
