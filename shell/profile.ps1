# Create the shortcut for environment resources
$ProfileConfigDir = "C:\Users\$env:UserName\Repo\shell_setup\shell\configuration"

# Import utility functions module
Import-Module "$ProfileConfigDir\utils.psm1"

# Load necessary modules
. "$ProfileConfigDir\modules.ps1"

# Define terminal colors
. "$ProfileConfigDir\colors.ps1"

# Set aliases
. "$ProfileConfigDir\global_aliases.ps1"
. "$ProfileConfigDir\local_aliases.ps1"

# Environmental variables
. "$ProfileConfigDir\envvars.ps1"

# Scripts to be sourced
. "$ProfileConfigDir\sources.ps1"
