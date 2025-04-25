####################################FUNCTIONS###################################
function Get-GitPushCommand {
    param (
        [string]$Target
    )

    switch ($Target) {
        "private" { "git push origin HEAD:refs/for/master%private" }
        "draft"   { "git push origin HEAD:refs/drafts/master" }
        "master"  { "git push origin HEAD:refs/for/master" }
        "main"    { "git push origin HEAD:main" }
        default   { throw 'git push: Unknown command!' }
    }
}

function Invoke-GitPush {
    param (
        [string]$Target
    )

    $cmd = Get-GitPushCommand -Target $Target
    Invoke-Expression $cmd
}

#################################AUTOCOMPLETION#################################
Register-ArgumentCompleter -CommandName Invoke-GitPush -ParameterName Target -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParams)

    "private", "draft", "master", "main" | Where-Object { $_ -like "$wordToComplete*" } | ForEach-Object {
        [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
    }
}

#####################################ALIASES####################################
Set-Alias -Name git-push -Value Invoke-GitPush