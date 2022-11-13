alias invhld='. $BASH_SCRIPTS_PATH/work_scripts/run_invhld/run_invhld.sh'
alias qt='/proj/Qt/Tools/QtCreator/bin/qtcreator &'

# Functions
function synch () {
    eval "rsync -prtv --delete --links /repo/$USER/ssi_be/ "\
         "sg317887@invhld$1://project/atsesvn/sg317887/trunk/ && echo -en '\''\x07'\'"
}

function synch_back () {
    eval "rsync -prtv --delete --links sg317887@invhld$1://project/atsesvn/sg317887/trunk/ "\
         "/repo/$USER/ssi_be/ && echo -en '\''\x07'\'"
}
