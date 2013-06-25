# Git
alias gp!='git push origin $(current_branch)'
alias gcb='git push -u origin $(current_branch)'
alias gs='git status'
alias gaa='git add --all'
alias gc='git commit'
alias gca='git commit --amend --date="$(date)"'
alias wip='gaa && gca -m "WIP"'
alias gsh='git show HEAD'
alias gd='git diff'
alias grev='git diff master'
alias gsu='git submodule foreach git pull origin master'

# Misc
alias retag='bundle list --paths=true | xargs ctags --extra=+f --exclude=.git --exclude=log --languages=-javascript -R *'
