###################################INSTRUCTIONS#################################
# Script argument: Name of directory where you wish to go. Script will use
# backward counting, when your argument will be name of directory.
################################################################################

# Import the module
Import-Module "$env:ScriptsPath\up_directory\up_directory.psm1"

# Define the alias
Set-Alias -Name upd -Value Invoke-UpDirectory