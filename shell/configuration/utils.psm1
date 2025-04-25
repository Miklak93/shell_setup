function Get-ChildItemColored {
    $items = Get-ChildItem
    foreach ($item in $items) {
        # Format Mode, LastWriteTime, Length (no color)
        $formattedItem = "{0,-20} {1,-25} {2,-10} " -f $item.Mode, $item.LastWriteTime, $item.Length
        Write-Host -NoNewline $formattedItem

        # Color only the Name (directories in yellow, files in white)
        if ($item.PSIsContainer) {
            # Print directory in yellow
            Write-Host $item.Name -ForegroundColor Yellow
        }
        else {
            # Print file in white
            Write-Host $item.Name -ForegroundColor White
        }
    }
}
