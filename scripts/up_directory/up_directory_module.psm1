####################################FUNCTIONS###################################

function Invoke-UpDirectory
{
    param(
        [string]$Target
    )

    if ([string]::IsNullOrWhiteSpace($Target)) {
        Set-Location -Path $HOME
        return
    }

    $currentPath = (Get-Location).Path
    $segments = $currentPath -split '[\\/]' | Where-Object { $_ -ne '' }

    $targetPath = ''
    foreach ($segment in $segments) {
        $targetPath = Join-Path $targetPath $segment
        if ($segment -eq $Target) { break }
    }

    if (Test-Path $targetPath)
    {
        Set-Location $targetPath
    }
    else
    {
        Write-Host "Target directory '$Target' not found in current path." -ForegroundColor Red
    }
}

#################################AUTOCOMPLETION#################################
Register-ArgumentCompleter -CommandName upd -ScriptBlock
{
    param(
        $commandName,
        $parameterName,
        $wordToComplete,
        $commandAst,
        $fakeBoundParameters
    )

    $currentPath = (Get-Location).Path
    $segments = $currentPath -split '[\\/]' | Where-Object { $_ -ne '' }

    $segments | Where-Object { $_ -like "$wordToComplete*" } | ForEach-Object {
        [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
    }
}

