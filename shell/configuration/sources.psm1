function _source_main_scripts {
    $SCRIPTS_PATH = $env:SCRIPTS_PATH

    # Loop through directories in the scripts path
    Get-ChildItem -Path $SCRIPTS_PATH -Directory | ForEach-Object
    {
        $directory = $_.FullName
        $mainScriptPath = Join-Path $directory "main.ps1"
        
        # If a main.ps1 file exists in the directory, dot source it
        if (Test-Path $mainScriptPath) {
            . $mainScriptPath
        }
    }
}

# Call the function to source the scripts
_source_main_scripts
