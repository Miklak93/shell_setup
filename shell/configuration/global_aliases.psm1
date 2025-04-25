# Alias for logoff (log off the user session)
Set-Alias logoff 'shutdown.exe -l'

# Alias for ls (list directory contents with options)
Set-Alias ls 'Get-ChildItem'

# Alias for ll (long listing format of directory contents)
Set-Alias ll 'Get-ChildItem -Force'

# Alias for rm -rf (remove files and directories recursively and forcefully)
Set-Alias rm -rf 'Remove-Item -Recurse -Force'