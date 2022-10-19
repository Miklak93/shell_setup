<div align="center">
      <h1>INSTRUCTIONS</h1>
</div>

## Preliminaries:
Start with

      sudo apt-get update
      sudo apt-get install git vim vim-gtk gnome-tweaks gnome-shell-extensions gnome-shell-extension-dash-to-panel dconf-editor xrdp

## General apperance:
**REMARK**
To have specific Ubuntu color configuration follow the instruction from https://github.com/Jannomag/Yaru-Colors.

* Type **Tweaks** in **Activities**, go to **Apperance** tab and set up
  * Applications: *Yaru*
  * Cursor: *DMZ-BLACK*
  * Icons: *Yaru*
* Type **Settings** in **Activities**, go to **Dock** under **Apperance** tab and set up
  * Position on screen: *Bottom*
  * Icon size: *24*
* In order to remove **Home** from Desktop type **Extensions** in **Activities** and disable *Desktop Icons*
* In order to merge **Activities** tab with **Dock** panel you need to log off, then go to **Gome tweaks**, click **Extensions** in the left and
  select *Dash to panel* (on Ubuntu 22.04 install gnome-shell-extension-manager and download "Dash to panel" plugin there https://itsfoss.com/extension-manager/)
* In order to disable logoff prompt
  * Type **dconf** in **Activities**
  * Move through **org** -> **gnome** -> **gnome-session**
  * Disable *Logout prompt*

## Terminal apperance
* Open terminal, click **Edit**, then **Preferences** and select
   * Text: Uncheck *Terminal bell*
   * Colors: *Custom* with:
      * Default color: #ADA4A4, #000000
      * Uncheck *Use transparency from system theme*
      * Check *Use transparent background*
   * Scrolling: uncheck *Limit scrollback*

## Remote connection
   Since you have installed xrdp go to /etc/xrdp/startwm.sh script and paste the following list just under the beginning
   script comment

    sudo sed -i '4 i\export XDG_CURRENT_DESKTOP=ubuntu:GNOME' /etc/xrdp/startwm.sh
    sudo sed -i '4 i\export GNOME_SHELL_SESSION_MODE=ubuntu' /etc/xrdp/startwm.sh
    sudo sed -i '4 i\export DESKTOP_SESSION=ubuntu' /etc/xrdp/startwm.sh

## Shell setup
   Clone this repository to */repo/$USER* and evaluate setup_shell.sh from scripts.
   Also remember to add <username> **ALL=(ALL) NOPASSWD: ALL** into your sudoers file (opening via "sudo visudo" command).
