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
plugins=(git git-completion git-flow brew gem npm osx rails bundler redis-cli ruby chruby docker)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...
source $HOME/.dotfiles/aliases.sh
source $HOME/Dropbox/aliases.sh
source $HOME/Dropbox/secrets.sh

# export CFLAGS="-g -02"
# export CC="/usr/local/bin/gcc-4.8"
# export GCC="/usr/local/bin/gcc-4.8"
# export CPP="/usr/local/bin/cpp-4.8"
# export CXX="/usr/local/bin/g++-4.8"
export LC_ALL=en_US.UTF-8
export TERM="xterm-256color"

# export JAVA_HOME=$(/usr/libexec/java_home -v 1.8)

export OPENSSL_ROOT_DIR=$(brew --prefix openssl)

export GOROOT="/usr/local/opt/go/libexec"
export GOPATH="$HOME/Code/go"

export RUST_HOME="/usr/local/Cellar/rust/1.5.0"
export PGDATA="/usr/local/var/postgres9.5"

export PATH="$HOME/bin:/usr/local/bin:$JAVA_HOME/bin:$GOROOT/bin:$GOPATH/bin:$RUST_HOME/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/sbin:/usr/X11/bin:/usr/local/heroku/bin"
export EDITOR="nvim"

# export RUBY_GC_HEAP_INIT_SLOTS=1000000
# export RUBY_HEAP_SLOTS_INCREMENT=1000000
# export RUBY_HEAP_SLOTS_GROWTH_FACTOR=1
# export RUBY_GC_MALLOC_LIMIT=100000000
# export RUBY_HEAP_FREE_MIN=500000

source /usr/local/opt/chruby/share/chruby/chruby.sh
source /usr/local/opt/chruby/share/chruby/auto.sh
chruby_auto
# chruby $(cat $HOME/.ruby-version)

# eval "$(chef shell-init zsh)"
# eval "$(/Users/luca/.chefvm/bin/chefvm init -)"
eval "$(docker-machine env dev)"

# added by travis gem
[ -f /Users/luca/.travis/travis.sh ] && source /Users/luca/.travis/travis.sh
