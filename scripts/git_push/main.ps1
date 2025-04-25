###################################INSTRUCTIONS#################################
# Script arguments: One of private, draft, master, main
################################################################################

# Import the module
Import-Module "$env:PSScriptsPath\git_push\git_push.psm1"

# Define the alias
Set-Alias -Name git-push -Value Invoke-GitPush