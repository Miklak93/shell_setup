####################################FUNCTIONS###################################

function Invoke-UpDirectory {
    param([string]$Target)

    if ([string]::IsNullOrWhiteSpace($Target)) {
        Set-Location -Path $HOME
        return
    }

    $currentPath = (Get-Location).Path
    $segments = $currentPath -split '[\\/]' | Where-Object { $_ -ne '' }

    $targetPath = ""
    foreach ($segment in $segments) {
        $targetPath += "$segment\"
        if ($segment -eq $Target) {
            Set-Location $targetPath
            return
        }
    }
    Write-Host "Target directory '$Target' not found in the current path." -ForegroundColor Red
}

#################################AUTOCOMPLETION#################################
Register-ArgumentCompleter -CommandName Invoke-UpDirectory -ParameterName Target -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)

    $currentPath = (Get-Location).Path
    $segments = $currentPath -split '[\\/]' | Where-Object { $_ -ne '' }

    # Only return completions if there are matching segments
    $segments | Where-Object { $_ -like "$wordToComplete*" } | ForEach-Object {
        [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
    }
}

#####################################ALIASES####################################
Set-Alias -Name upd -Value Invoke-UpDirectory
