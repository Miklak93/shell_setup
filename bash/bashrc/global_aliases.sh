#COMMANDS
alias logoff='gnome-session-quit'
alias ls='ls $LS_OPTIONS'
alias ll='ls -la'
alias lls='ls -l'
alias push_on_draft='git push origin HEAD:refs/drafts/master'
alias push_on_master='git push origin HEAD:refs/for/master'

#SCRIPTS - scripts variable is set in envvars
alias dn='. $BASH_SCRIPTS_PATH/directory_navigator/directory_navigator.sh'
alias git-push='. $BASH_SCRIPTS_PATH/git_push/git_push.sh'
alias prompt-title='. $BASH_SCRIPTS_PATH/prompt_title/prompt_title.sh'
alias run-after='. $BASH_SCRIPTS_PATH/run_after/run_after.sh'
alias run-forever='. $BASH_SCRIPTS_PATH/run_forever/run_forever.sh'
alias upd='. $BASH_SCRIPTS_PATH/up_directory/up_directory.sh'
