###################################INSTRUCTIONS#################################
# Script arguments: Short directory name saved in directory navigator dababase.
################################################################################

# Import the module
Import-Module "$env:PSScriptsPath\dynamic_alias\dynamic_alias.psm1"

# Define the alias
Set-Alias -Name da -Value Invoke-DynamicAlias