#COMMANDS
alias ll='ls -la'
alias lls='ls -l'
alias push_on_draft='git push origin HEAD:refs/drafts/master'
alias push_on_master='git push origin HEAD:refs/for/master'
alias qt='qtcreator &'
alias eclipse='/usr/share/eclipse-dsl/eclipse/eclipse &'

#SCRIPTS - scripts variable is set in envvars
alias dn='. $BASH_SCRIPTS_PATH/directory_navigator/directory_navigator.sh'
alias prompt-title='. $BASH_SCRIPTS_PATH/prompt_title/prompt_title.sh'
alias run-forever='. $BASH_SCRIPTS_PATH/run_forever/run_forever.sh'
alias upd='. $BASH_SCRIPTS_PATH/up_directory/up_directory.sh'
