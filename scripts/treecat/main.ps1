# ======================================= INSTRUCTIONS =========================================== #
# Script argument: Name of the directory you wish to inspect using treecat.
# This script prints all files in the directory along with their contents.
# Tab-completion is supported for directory names.
# ================================================================================================ #

# ========================================= CONFIG ================================================ #
# Expecting treecat.py to be at: $env:ShellSetupScriptsPath\treecat\treecat.py
# ================================================================================================ #

# ======================================== FUNCTIONS ============================================== #
# Helper functions
# ================================================================================================ #
function Invoke-Treecat {
    param (
        [string]$Target
    )

    $scriptPath = Join-Path $env:ShellSetupScriptsPath "treecat\treecat.py"
    if (-Not (Test-Path $scriptPath)) {
        Write-Host "Error: treecat.py not found at $scriptPath" -ForegroundColor Red
        return
    }

    try {
        python $scriptPath $Target
    } catch {
        Write-Host "Error running treecat: $_" -ForegroundColor Red
    }
}

# ========================================= ALIAS ================================================= #
# Define the alias command name
# ================================================================================================ #
Set-Alias -Name treecat -Value Invoke-Treecat

# =================================== AUTOCOMPLETION ============================================== #
# Enable autocompletion for the directory argument
# ================================================================================================ #
Register-ArgumentCompleter -CommandName Invoke-Treecat -ParameterName Target -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)

    $currentPath = Get-Location
    $dirs = Get-ChildItem -Path $currentPath -Directory | ForEach-Object { $_.Name }

    $specialDirs = @('.', '..')
    $allDirs = $specialDirs + $dirs

    $allDirs | Where-Object { $_ -like "$wordToComplete*" } | ForEach-Object {
        [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
    }
}
