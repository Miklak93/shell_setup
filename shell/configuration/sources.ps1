# Call the function to source the scripts
$scriptsPath = $env:ShellSetupScriptsPath

# Ensure the path is valid
if (-not (Test-Path $scriptsPath))
{
    Write-Host "The specified scripts path does not exist: $scriptsPath"
    return
}

# Loop through directories in the scripts path
$directories = Get-ChildItem -Path $scriptsPath -Directory
foreach ($directory in $directories)
{
    $mainScriptPath = Join-Path $directory.FullName "main.ps1"
    
    # If a main.ps1 file exists in the directory, dot source it
    if (Test-Path $mainScriptPath)
    {
        . $mainScriptPath
    }
}
