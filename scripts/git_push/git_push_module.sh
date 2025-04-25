#!/bin/bash

####################################FUNCTIONS###################################
_get_command()
{
    case "${1}" in
        "private")
            echo "git push origin HEAD:refs/for/master%private";;
        "draft")
            echo "git push origin HEAD:refs/drafts/master";;
        "master")
            echo "git push origin HEAD:refs/for/master";;
        "main")
            echo "git push origin HEAD:main";;
        *)
            echo "echo 'unknown command!'"
    esac
}

_git_push()
{
    local cmd="$(_get_command ${1})"
    eval "${cmd}"
}

#################################AUTOCOMPLETION#################################
_git_push_autocompletion()
{
    COMPREPLY=()

    local current_word="${COMP_WORDS[COMP_CWORD]}"
    local possible_words="private draft master main"

    COMPREPLY=( $(compgen -W "${possible_words}" -- ${current_word}) )

    return 0
}
