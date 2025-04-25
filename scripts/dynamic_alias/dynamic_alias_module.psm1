$Global:DynamicAliasData = "$env:PSScriptsPath\dynamic_alias\.dynamic_alias_data"

####################################FUNCTIONS###################################
function Get-DirectoryShortNames
{
    Get-Content $Global:DynamicAliasData | ForEach-Object { ($_ -split '\s+')[0] }
}

function Expand-ShortName
{
    param([string]$ShortName)
    $match = Select-String -Path $Global:DynamicAliasData -Pattern "^\s*$ShortName\s" | Select-Object -First 1
    if ($match) {
        return ($match.Line -split '\s+')[1]
    }
    return $null
}

function Build-FullPath
{
    param(
        [string]$ShortName,
        [string[]]$Suffix
    )
    $base = Expand-ShortName $ShortName
    if (-not $base) { return $null }
    $suffixPath = ($Suffix -join '').Replace(' ', '')
    return Join-Path $base $suffixPath
}

function Add-DynamicAlias
{
    param(
        [string]$ShortName,
        [string]$FullPath
    )
    Add-Content -Path $Global:DynamicAliasData -Value "$ShortName $FullPath"
}

function Remove-DynamicAlias
{
    param([string]$ShortName)
    $lines = Get-Content $Global:DynamicAliasData | Where-Object { $_ -notmatch "^\s*$ShortName\s" }
    Set-Content -Path $Global:DynamicAliasData -Value $lines
}

function List-DynamicAliases
{
    Get-Content $Global:DynamicAliasData
}

function Invoke-DynamicAlias
{
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$ActionOrAlias,
        [Parameter(Position = 1)]
        [string]$Arg1,
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Rest
    )

    switch ($ActionOrAlias) {
        'add-record'    { Add-DynamicAlias $Arg1 (Get-Location).Path }
        'remove-record' { Remove-DynamicAlias $Arg1 }
        'list-records'  { List-DynamicAliases }
        default {
            $fullPath = Build-FullPath -ShortName $ActionOrAlias -Suffix @($Arg1) + $Rest
            if ($fullPath -and (Test-Path $fullPath)) {
                Set-Location $fullPath
            } else {
                Write-Host "Invalid alias or path: $ActionOrAlias" -ForegroundColor Red
            }
        }
    }
}

#################################AUTOCOMPLETION#################################
Register-ArgumentCompleter -CommandName da -ScriptBlock
{
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)

    $args = $commandAst.CommandElements | Select-Object -Skip 1 | ForEach-Object { $_.ToString() }
    $args = $args[0..($args.Count - 2)]  # Remove current (incomplete) word

    $results = @()
    if ($args.Count -eq 0) {
        $results = Get-DirectoryShortNames
    } else {
        $fullPath = Build-FullPath -ShortName $args[0] -Suffix $args[1..($args.Count - 1)]
        if ($fullPath -and (Test-Path $fullPath)) {
            $results = Get-ChildItem -Path $fullPath -Directory | ForEach-Object { $_.Name }
        }
    }

    $results | Where-Object { $_ -like "$wordToComplete*" } | ForEach-Object {
        [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
    }
}

