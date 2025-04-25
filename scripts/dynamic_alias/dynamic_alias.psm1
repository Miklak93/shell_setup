$DynamicAliasData = "$env:ScriptsPath\dynamic_alias\.dynamic_alias_data.ps1"

####################################FUNCTIONS###################################
function Get-DirectoryShortNames
{
    Get-Content $DynamicAliasData | ForEach-Object { ($_ -split '\s+')[0] }
}

function Expand-ShortName
{
    param([string]$ShortName)
    $match = Select-String -Path $DynamicAliasData -Pattern "^\s*$ShortName\s" | Select-Object -First 1
    if ($match) {
        return ($match.Line -split '\s+')[1]
    }
    return $null
}

function Get-FullPath
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
        [string]$AbsPath
    )
    if (!$ShortName)
    {
        $ShortName = Split-Path -Path $AbsPath -Leaf
    }
    Add-Content -Path $DynamicAliasData -Value "$ShortName $AbsPath"
}

function Set-DynamicAlias
{
    param
    (
        [string]$shortName
    )

    # Read the dynamic alias data from the file
    $aliasData = Get-Content $DynamicAliasData

    # Find the matching line for the short name (first column)
    $matchingLine = $aliasData | Where-Object { ($_ -split '\s+')[0] -eq $shortName }

    if ($matchingLine) {
        # Extract the full path from the second column
        $fullPath = ($matchingLine -split '\s+')[1]

        # Check if the path exists
        if (Test-Path $fullPath) {
            Set-Location $fullPath
        } else {
            throw "DynamicAlias: Path does not exist: $fullPath"
        }
    } else {
        throw "DynamicAlias: Invalid alias or path: $shortName"
    }
}

function Remove-DynamicAlias
{
    param([string]$ShortName)
    $lines = Get-Content $DynamicAliasData | Where-Object { $_ -notmatch "^\s*$ShortName\s" }
    Set-Content -Path $DynamicAliasData -Value $lines
}

function Get-DynamicAliases
{
    Get-Content $DynamicAliasData
}

function Invoke-DynamicAlias
{
    param(
        [switch]$AddRecord,
        [switch]$RemoveRecord,
        [switch]$ApplyRecord,
        [switch]$GetRecords,
        [string]$ShortName
    )

    if ($AddRecord) { 
        Add-DynamicAlias $ShortName (Get-Location).Path
    }
    elseif ($RemoveRecord) { 
        Remove-DynamicAlias $ShortName
    }
    elseif ($GetRecords) {
        Get-DynamicAliases
    }
    else {
        Set-DynamicAlias $ShortName
    }
}

#################################AUTOCOMPLETION#################################
Register-ArgumentCompleter -CommandName Invoke-DynamicAlias -ParameterName ShortName -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)

    # Define static actions
    $staticOptions = @(
        '-AddRecord',
        '-RemoveRecord',
        '-GetRecords',
        '-ApplyRecord'
    )

    # Get provided arguments
    $arguments = $commandAst.CommandElements | Select-Object -Skip 1 | ForEach-Object { $_.ToString() }
    $providedSwitch = $arguments | Where-Object { $_ -like '-*' } | Select-Object -First 1

    $dynamicOptions = Get-DirectoryShortNames

    # Default case: no switch yet => show both static and dynamic
    if (-not $providedSwitch) {
        $results = $staticOptions + $dynamicOptions
    }
    # Specific switch: show only aliases
    elseif ($providedSwitch -in ('-ApplyRecord', '-RemoveRecord')) {
        $results = $dynamicOptions
    }
    # AddRecord and GetRecords don’t need shortName
    else {
        $results = @()
    }

    # Filter by current input, allowing all with '*' (trick to print all possible options)
    $filter = if ([string]::IsNullOrWhiteSpace($wordToComplete)) { '*' } else { "$wordToComplete*" }
    $results = $results | Where-Object { $_ -like $filter }

    $results | ForEach-Object {
        [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
    }
}

#####################################EXPORT#####################################
Export-ModuleMember -Function Invoke-DynamicAlias