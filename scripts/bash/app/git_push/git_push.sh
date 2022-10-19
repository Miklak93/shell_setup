#!/bin/bash
###################################INSTRUCTIONS#################################
# Script arguments: One of private, draft, master, main
####################################FUNCTIONS###################################
_get_command() {
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

_git_push() {
    local cmd="$(_get_command ${1})"
    eval "${cmd}"
}

######################################MAIN######################################
_git_push "$1"
