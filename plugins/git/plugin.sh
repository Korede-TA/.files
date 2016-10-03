alias g=git

# Don't load configuration from /etc (use our local configuration only)
export GIT_CONFIG_NOSYSTEM=1

active_git_branch () {
  local ref=`git symbolic-ref HEAD 2> /dev/null`
  echo "${ref#refs/heads/}"
}

git_branch_ahead () {
  local branch=`active_git_branch`
  `git log origin/$branch..HEAD 2> /dev/null | grep '^commit' &> /dev/null` \
    && echo '➨'
}
