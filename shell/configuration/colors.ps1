# Set the background color to black
$host.UI.RawUI.BackgroundColor = "Black"  

# Set the text color (foreground) to white
$host.UI.RawUI.ForegroundColor = "White"     

# Apply the color changes
Clear-Host  # Clear the terminal to apply the new colors

# Customizing the prompt to display the header
function prompt
{
    # Basic info
    $user = $env:USERNAME
    $time = (Get-Date).ToString("HH:mm:ss")
    $path = Get-Location

    # Git info
    $gitInfo = ""
    try
    {
        $repoRoot = git rev-parse --show-toplevel 2>$null
        if ($repoRoot)
        {
            $repoName = Split-Path $repoRoot -Leaf
            $branch = git rev-parse --abbrev-ref HEAD 2>$null
            $gitInfo = " [$repoName,$branch]"
        }
    } catch {
        # No git info
    }

    # Write each part with its own color
    Write-Host -NoNewline $user -ForegroundColor DarkGray
    Write-Host -NoNewline " "
    Write-Host -NoNewline $time -ForegroundColor Yellow
    Write-Host -NoNewline " "
    Write-Host -NoNewline "($path)" -ForegroundColor DarkYellow
    
    if ($gitInfo) {
        Write-Host -NoNewline $gitInfo -ForegroundColor Green
    }
    
    # Input line
    return "`n-> "
}
