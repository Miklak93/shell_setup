# Define the repository and scripts paths using the $USER environment variable
$RepoPath = "C:\Users\$env:UserName\Repo"

$env:ScriptsPath = "$RepoPath\shell_setup\scripts"
