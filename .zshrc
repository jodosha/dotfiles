# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="jodosha"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(iterm2 zsh-autosuggestions git git-flow extract fancy-ctrl-z brew osx ruby chruby gem bundler golang postgres redis-cli docker tmux)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...

source $HOME/.dotfiles/aliases.sh
source $HOME/Dropbox/aliases.sh
source $HOME/Dropbox/secrets.sh

export LC_ALL=en_US.UTF-8
export TERM="xterm-256color"

# export JAVA_HOME=$(/usr/libexec/java_home -v 1.8)

export OPENSSL_ROOT_DIR=$(brew --prefix openssl)

export GOROOT="/usr/local/opt/go/libexec"
export GOPATH="$HOME/Code/go"

export RUST_HOME="/usr/local/Cellar/rust/1.5.0"
export PGDATA="/usr/local/var/postgres9.5"

export GOOGLE_APPLICATION_CREDENTIALS="/Users/luca/Dropbox/google-vision.json"

export PATH="$HOME/bin:/usr/local/bin:/usr/local/opt/curl-openssl/bin:$JAVA_HOME/bin:$GOROOT/bin:$GOPATH/bin:/usr/local/opt/postgresql@10/bin:$RUST_HOME/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/sbin:/usr/X11/bin:/usr/local/heroku/bin"
export EDITOR="nvim"
export NVIM_TUI_ENABLE_TRUE_COLOR=1
export GPG_TTY=$(tty)

source /usr/local/opt/chruby/share/chruby/chruby.sh
source /usr/local/opt/chruby/share/chruby/auto.sh
chruby_auto

BASE16_SHELL=$HOME/.config/base16-shell/
[ -n "$PS1" ] && [ -s $BASE16_SHELL/profile_helper.sh ] && eval "$($BASE16_SHELL/profile_helper.sh)"

# added by travis gem
[ -f /Users/luca/.travis/travis.sh ] && source /Users/luca/.travis/travis.sh
export PATH="/usr/local/opt/openssl/bin:$PATH"
eval "$(direnv hook zsh)"
export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"
