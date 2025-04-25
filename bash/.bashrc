BASHRC_CONFIG_DIR="/repo/$USER/shell_setup/bash/configuration"

# Set 256 colors in terminal - use only when needed
#. /etc/profile.d/256term.sh

# Bash options
shopt -s checkwinsize

# Enable bash completion
. /usr/share/bash-completion/bash_completion

# Enable git completion
. /etc/bash_completion.d/git-prompt

# Load necessary modules
. "$BASHRC_CONFIG_DIR/modules.sh"

# Define terminal colors
. "$BASHRC_CONFIG_DIR/colors.sh"

# Set aliases
. "$BASHRC_CONFIG_DIR/global_aliases.sh"
. "$BASHRC_CONFIG_DIR/local_aliases.sh"

# Environmental variables
. "$BASHRC_CONFIG_DIR/envvars.sh"

# Scripts to source
. "$BASHRC_CONFIG_DIR/sources.sh"

# Functions and utils
. "$BASHRC_CONFIG_DIR/utils.sh"

# Disable ctrl + 1 ssty signal sent to have block text matching in vim
stty start undef