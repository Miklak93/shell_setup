$PROFILE_CONFIG_DIR = "C:\Users\$env:USER\Repo\shell_setup\shell\configuration"

Import-Module "$PROFILE_CONFIG_DIR\modules.psm1"
Import-Module "$PROFILE_CONFIG_DIR\colors.psm1"
Import-Module "$PROFILE_CONFIG_DIR\envvars.psm1"
Import-Module "$PROFILE_CONFIG_DIR\global_aliases.psm1"
Import-Module "$PROFILE_CONFIG_DIR\local_aliases.psm1"
Import-Module "$PROFILE_CONFIG_DIR\sources.psm1"
Import-Module "$PROFILE_CONFIG_DIR\utils.psm1"
