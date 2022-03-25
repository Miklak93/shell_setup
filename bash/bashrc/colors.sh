# Basic colors for 8/16 palette
GREEN="\e[32m"
YELLOW="\e[33m"

# 38 prefix is used for letters color from 256 palette
SIN_RED="\e[38;5;166m"
SIN_BLUE="\e[38;5;69m"
SIN_GREY="\e[38;5;246m"
SIN_ORANGE="\e[38;5;208m"

# 48 prefix is used for background colour from 256 palette - not needed here
git_prompt ()
{
        if ! git rev-parse --git-dir > /dev/null 2>&1; then
            return 0
        fi

        full_repo_name=$(git rev-parse --show-toplevel)
        git_branch=$(git branch 2>/dev/null| sed -n '/^\*/s/^\* //p')

        if git diff --quiet 2>/dev/null >&2; then
            git_color="${c_git_clean}"
        else
            git_color=${c_git_dirty}
        fi

        echo "${c_git_clean}[$git_color${full_repo_name##*/},$git_branch${c_reset}${c_git_clean}] "
}

# Values \n, \h, \u itd are special bash prompt characters - see instructions
PS1="${SIN_GREY}\u ${YELLOW}\t ${SIN_ORANGE}(\w) ${GREEN}\$(git_prompt)${SIN_RED} $(tput sgr0)\n-> "
