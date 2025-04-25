# Define the repository and scripts paths using the $USER environment variable
$global:REPO_PATH = "C:\Users\$env:USER\Repo"
$global:SCRIPTS_PATH = "$global:REPO_PATH\shell_setup\scripts"

# Add the scripts path to the environment PATH
$env:PATH = "$global:SCRIPTS_PATH;$env:PATH"

