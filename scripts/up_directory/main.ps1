# ======================================= INSTRUCTIONS =========================================== #
# Script argument: Name of directory where you wish to go. Script will use
# backward counting, when your argument will be name of directory.
# ================================================================================================ #

# ========================================= CONFIG ==========================================+==== #
# Configuration variables
# ================================================================================================ #

# ======================================== FUNCTIONS ============================================= #
# Helper functions
# ================================================================================================ #
function Invoke-UpDirectory {
    param (
        [string]$Target
    )

    $directory = py "$env:ShellSetupScriptsPath\up_directory\main.py" "$Target"
    if ( $directory -like "Error*" ) {
        Write-Host "$directory" -ForegroundColor Red
    } else {
        Set-Location -Path "$directory"
    }
}

# ========================================= ALIAS ================================================ #
# Define the name of the command as it appears in the shell                                        #
# ================================================================================================ #
Set-Alias -Name upd -Value Invoke-UpDirectory

#===================================== AUTOCOMPLETION ============================================ #
# AUTOCOMPLETION: Enable autocompletion for the command in the shell                               #
# ================================================================================================ #
Register-ArgumentCompleter -CommandName Invoke-UpDirectory -ParameterName Target -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)

    $currentPath = (Get-Location).Path
    $segments = $currentPath -split '[\\/]' | Where-Object { $_ -ne '' }

    # Only return completions if there are matching segments
    $segments | Where-Object { $_ -like "$wordToComplete*" } | ForEach-Object {
        [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
    }
}
