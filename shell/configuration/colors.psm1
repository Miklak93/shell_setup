# colors.psm1 - PowerShell module equivalent of colors.sh

# Define basic colors
$global:Green = [ConsoleColor]::Green
$global:Yellow = [ConsoleColor]::Yellow
$global:SIN_RED = [ConsoleColor]::DarkRed
$global:SIN_BLUE = [ConsoleColor]::Blue
$global:SIN_GREY = [ConsoleColor]::Gray
$global:SIN_ORANGE = [ConsoleColor]::DarkYellow

# Function to set up basic color for file listing
function Set-FileListingColors
{
    $global:LS_OPTIONS = '--color=auto'
    $global:LS_COLORS = @{
        'di' = $global:Yellow
        'ex' = $global:Green
        'ln' = $global:SIN_GREY
    }
}

# Function to get the current Git branch (if in a git repo)
function Get-GitBranch
{
    if (Test-Path .git) {
        $gitBranch = git rev-parse --abbrev-ref HEAD
        return $gitBranch
    }
    return ""
}

# Custom prompt function
function prompt
{
    $currentDir = Get-Location
    $gitBranch = Get-GitBranch

    $promptString = "$($currentDir) "
    if ($gitBranch) {
        $promptString += "($gitBranch)"
    }

    $Host.UI.RawUI.ForegroundColor = $global:SIN_GREY
    return "$promptString> "
}
