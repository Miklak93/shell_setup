# ======================================= INSTRUCTIONS =========================================== #
# Script arguments: Short directory name saved in directory navigator dababase.
# ================================================================================================ #

# ========================================= CONFIG ==========================================+==== #
# Configuration variables
# ================================================================================================ #

# ======================================== FUNCTIONS ============================================= #
# Helper functions
# ================================================================================================ #
function Invoke-DynamicAlias {
    $Result = py "$env:ShellSetupScriptsPath\dynamic_alias\main.py" $args

    if ($Result -like "Command:*") {
        $rawCommand = $result.Substring(8).Trim()
        $exeCommand = $rawCommand -replace "'([^']+)'", '$1'
        Invoke-Expression "$exeCommand"
    } elseif ($Result -like "*Error:*") {
        Write-Host "$Result`n" -ForegroundColor Red
    } elseif ($Result -like "*Success:*") {
        Write-Host "$Result`n" -ForegroundColor Green
    } else {
        Write-Output "$Result`n"
    }
}

# ========================================= ALIAS ================================================ #
# Define the name of the command as it appears in the shell                                        #
# ================================================================================================ #
Set-Alias -Name da -Value Invoke-DynamicAlias

#===================================== AUTOCOMPLETION ============================================ #
# Enable autocompletion for the command in the shell                                               #
# ================================================================================================ #
