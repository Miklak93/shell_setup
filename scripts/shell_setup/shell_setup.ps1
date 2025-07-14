# PowerShell script to set up symlinks, profile, aliases, and environment variables

# Define paths based on the user's environment
$ShellSetupPath = (Get-Item -LiteralPath $PSScriptRoot).Parent.Parent.FullName
$ShellSetupVimPath = "$ShellSetupPath\vim"
$ShellSetupScriptsPath = "$ShellSetupPath\scripts"
$ShellSetupProfilesPath = "$ShellSetupPath\shell"
$ShellSetupConfigurationPath = "$ShellSetupProfilesPath\configuration"
$ShellSetupDonePath = ".shell_setup_done.ps1"

# Function to create symlinks for Vim
function Set-Link {
    param (
        [string]$Source,
        [string]$Destination
    )

    # Remove the existing symbolic link if it exists and create a new one
    if (Test-Path $Destination) { Remove-Item -Path $Destination -Force }
    New-Item -ItemType SymbolicLink -Path $Destination -Target $Source
}

# Set up the Vim links
function Set-Links {
    $vimSourcePath = "$ShellSetupVimPath\.vim"
    $vimrcSourcePath = "$ShellSetupVimPath\.vimrc"

    # Check if the files exist before creating symlinks
    if (Test-Path $vimSourcePath) {
        Set-Link -Source $vimSourcePath -Destination "$env:USERPROFILE\.vim"
    } else {
        throw "Vim source file not found: $vimSourcePath"
    }

    if (Test-Path $vimrcSourcePath) {
        Set-Link -Source $vimrcSourcePath -Destination "$env:USERPROFILE\.vimrc"
    } else {
        throw "Vimrc source file not found: $vimrcSourcePath"
    }
}

# Set up the environment variables and profile configurations
function Set-Files {
    $EnvVarsPath = "$ShellSetupConfigurationPath\envvars.ps1"
    $Content = "`$env:ShellSetupScriptsPath = '$ShellSetupScriptsPath'"

    # Check if the file exists
    if (Test-Path $EnvVarsPath) {
        # Read the content of the file
        $ExistingContent = Get-Content -Path $EnvVarsPath -Raw

        # Add as first line
        if (-not $ExistingContent) {
            Add-Content -Path $EnvVarsPath -Value "$Content" -Force
        }
        
        # Add as next line
        if ($ExistingContent -notmatch [regex]::Escape($Content)) {
            Add-Content -Path $EnvVarsPath -Value "`r`n$Content" -Force
        }
    }
    else {
        # If the file doesn't exist, create it and add the content
        Set-Content -Path $EnvVarsPath -Value $Content -Force
    }
}

# Set up aliases and dynamic alias data
function Set-Aliases {
    $LocalAliasesPath = "$ShellSetupConfigurationPath\local_aliases.ps1"

    if (-not (Test-Path $LocalAliasesPath)) {
        New-Item -ItemType File -Path $LocalAliasesPath
    }
}

# Set up the profile by appending the profile.ps1 reference
function Set-Profile {
    $RepositoryProfilePath = "$ShellSetupProfilesPath\profile.ps1"

    # Define the content to add to the profile
    $ProfileContent = "if (Test-Path $RepositoryProfilePath) { . $RepositoryProfilePath }"

    # If the profile exists, modify it, otherwise create a new one
    if (Test-Path $PROFILE) {
        # Read the current content of the profile
        $ProfileFileContent = Get-Content -Path $PROFILE
        
        # Remove any existing entries with the same path
        $ProfileFileContent = $ProfileFileContent | Where-Object { $_ -notmatch [regex]::Escape($ProfileContent) }
        
        # Add the new profile content
        $ProfileFileContent += $ProfileContent
        
        # Write the modified content back to the profile file
        Set-Content -Path $PROFILE -Value $ProfileFileContent -Force
    }
    else {
        # Create a new profile file and add the content
        Set-Content -Path $PROFILE -Value $ProfileContent -Force
    }
}

function Reset-Shell {
    Remove-Item -Path $ShellSetupDonePath -Force

    $profileDir = Split-Path $PROFILE
    if (-not (Test-Path $profileDir)) {
        New-Item -ItemType Directory -Path $profileDir -Force
    }

    Set-Links
    Set-Files
    Set-Aliases
    Set-Profile

    New-Item -Path $ShellSetupDonePath -ItemType File -Force
}

# Reset the shell setup by cleaning up files and re-running the setup functions
function Set-Shell {
    # Prompt the user only if setup has not been done already
    $doReset = "Y"
    if (Test-Path $ShellSetupDonePath) {
        $doReset = Read-Host "Shell is already set up - Do you really want to reset settings? [Y/N]"
    }

    if ($doReset -match '^[Yy]$') {
        Reset-Shell
        Write-Host "Done!"
    }
    elseif ($doReset -match '^[Nn]$') {
        Write-Host "Shell has not been reset!"
    }
    else {
        Write-Host "Command not recognized!"
    }
}

# Main entry point
Set-Shell
