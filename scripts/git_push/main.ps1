# ======================================= INSTRUCTIONS =========================================== #
# Script arguments: One of private, draft, master, main                                            #
# ================================================================================================ #

# ======================================== FUNCTIONS ============================================= #
# Helper functions
# ================================================================================================ #
function Invoke-GitPush {
    param (
        [string]$Branch
    )

    py "$env:ShellSetupScriptsPath\git_push\main.py" "$Branch"
}

# ========================================= ALIAS ================================================ #
# Define the name of the command as it appears in the shell                                        #
# ================================================================================================ #
Set-Alias -Name git-push -Value Invoke-GitPush

#===================================== AUTOCOMPLETION ============================================ #
# AUTOCOMPLETION: Enable autocompletion for the command in the shell                               #
# ================================================================================================ #
Register-ArgumentCompleter -CommandName Invoke-GitPush -ParameterName Branch -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParams)

    "private", "draft", "master", "main" | Where-Object { $_ -like "$wordToComplete*" } | ForEach-Object {
        [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
    }
}
