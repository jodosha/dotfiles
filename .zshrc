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
plugins=(iterm2 zsh-autosuggestions git git-flow extract fancy-ctrl-z brew macos ruby chruby gem bundler golang postgres redis-cli docker tmux)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...

source $HOME/.dotfiles/aliases.sh
source $HOME/Dropbox/aliases.sh
source $HOME/Dropbox/secrets.sh

export LC_ALL=en_US.UTF-8
export TERM="xterm-256color"

export LDFLAGS="-L/usr/local/opt/openssl@1.1/lib"
export CPPFLAGS="-I/usr/local/opt/openssl@1.1/include"
export PKG_CONFIG_PATH="/usr/local/opt/openssl@1.1/lib/pkgconfig"
export DYLD_LIBRARY_PATH="/usr/local/Cellar/openssl@1.1/1.1.1i/lib:$DYLD_LIBRARY_PATH"

export GOROOT="/usr/local/opt/go/libexec"
export GOPATH="$HOME/Code/go"

# export GOOGLE_APPLICATION_CREDENTIALS="/Users/luca/Dropbox/google-vision.json"

export PATH="$HOME/bin:$HOME/Dropbox/scripts:/usr/local/bin:/usr/local/opt/curl-openssl/bin:/usr/local/opt/openjdk@11/bin:$GOROOT/bin:$GOPATH/bin:/Applications/Docker.app/Contents/Resources/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/sbin:/usr/X11/bin:/usr/local/heroku/bin"
export EDITOR="lvim"
export NVIM_TUI_ENABLE_TRUE_COLOR=1
export GPG_TTY=$(tty)

source /usr/local/opt/chruby/share/chruby/chruby.sh
source /usr/local/opt/chruby/share/chruby/auto.sh
chruby_auto

source "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
source "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"

export PATH="/usr/local/opt/openssl@1.1/bin:$PATH"
eval "$(direnv hook zsh)"
# export PATH="$HOME/.jenv/bin:$PATH"
# eval "$(jenv init -)"
export PATH="/usr/local/opt/elasticsearch@5.6/bin:$PATH"
export PATH="/Users/jodosha/.local/bin:$PATH"
source "$HOME/.cargo/env"

export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && \. "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
