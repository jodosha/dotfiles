# Git
alias gp!='git push origin $(current_branch)'
alias gpb='git push -u origin $(current_branch)'
alias gs='git status'
alias gaa='git add --all'
alias gc='git commit'
alias gca='git commit --amend --date="$(date)"'
alias wip='gaa && gca -m "WIP"'
alias gsh='git show HEAD'
alias gd='git diff'
alias grev='git diff master'
alias gsu='git submodule foreach git pull origin master'
alias changelog='git log --format="%h %ai %an %s"'
alias ggpull='git pull --rebase'

# Misc
alias dnsflush='dscacheutil -flushcache'
alias sharp='vim $HOME/Documents/Work/sharp.txt'
alias a='vim $HOME/.dotfiles/aliases.sh'
alias web='ruby -run -e httpd . -p 5000'
alias ber="bundle exec rake"
