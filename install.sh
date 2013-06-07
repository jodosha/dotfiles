#!/bin/sh

set -e
DOTFILES_ROOT="$HOME/.dotfiles"
cd "$HOME"

ln_s () {
  ln -sfn "$DOTFILES_ROOT/$1" "$2"
}

echo "Checking for SSH key, generating one if it doesn't exist"
  [[ -f ~/.ssh/id_rsa.pub ]] || ssh-keygen -t rsa

echo "Copying public key to clipboard. Paste it into your Github account"
  [[ -f ~/.ssh/id_rsa.pub ]] && cat ~/.ssh/id_rsa.pub | pbcopy
  open https://github.com/account/ssh

echo "Installing Homebrew"
  /usr/bin/ruby -e "$(/usr/bin/curl -fksSL https://raw.github.com/mxcl/homebrew/master/Library/Contributions/install_homebrew.rb)"
  brew update

echo "Installing OpenSSL"
  brew install openssl

echo "Installing Git"
  brew install git
  brew install git-flow

echo "Installing Ack"
  brew install ack

echo "Installing Tmux"
  brew install tmux

echo "Installing Vim"
  curl ftp://ftp.vim.org/pub/vim/unix/vim-7.3.tar.bz2 | tar -xz
  cd vim73 && ./configure --with-features=huge --enable-cscope --enable-rubyinterp --enable-multibyte --enable-clipboard=yes --enable-xterm_clipboard=yes && make && sudo make install
  cd .. && rm -rf vim*

echo "Installing PostgreSQL"
  brew install postgres --no-python
  initdb /usr/local/var/postgres

echo "Installing Redis"
  brew install redis

echo "Install MongoDB"
  brew install mongo

echo "Installing Node"
  brew install node
  curl http://npmjs.org/install.sh | sh

echo "Installing Rbenv"
  brew install rbenv
  brew install ruby-build

echo "Installing Ruby"
  export RUBY_CONFIGURE_OPTS="--enable-dtrace --with-opt-dir=`brew --prefix openssl`"
  rbenv install 2.0.0-p195
  if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi
  rbenv global 2.0.0-p195
  rbenv rehash

echo "** Installing basic gems"
  echo 'gem: --no-ri --no-rdoc' > ~/.gemrc
  gem install bundler
  gem install rails
  gem install heroku

echo "** Configuring RubyGems.org account"
  mkdir -p ~/.gem
  curl -u jodosha https://rubygems.org/api/v1/api_key.yaml > ~/.gem/credentials

  rbenv rehash

echo "** Configuring Heroku account"
  heroku auth:login

echo "Cloning dotfiles repo"
  rm -rf ~/.dotfiles
  git clone git@github.com:jodosha/dotfiles.git ~/.dotfiles

echo "Installing Oh-My-ZSH"
  git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
  ln_s jodosha.zsh-theme .oh-my-zsh/themes
  ln_s .zshrc .
  chsh -s /bin/zsh

echo "Configuring Tmux"
  ln_s .tmux.conf .

echo "Configuring Git"
  ln_s .gitconfig .

echo "Installing user defined scripts"
  mkdir -p ~/bin
  ls bin | while read script; do ln_s "bin/$script" bin; done

# echo "Installing fonts"
#   ls fonts | while read font; do open $font; done

# echo "Configuring iTerm2"
#   open iTerm/Tomorrow\ Night.itermcolors
#   cp iTerm/com.googlecode.iterm2.plist ~/Library/Preferences

echo "Configuring Vim"
  ln_s .vim .
  ln_s .vimrc .

echo "** Installing Vim plugins"
  upgrade_vim

echo "Reloading the shell"
  exec $SHELL -l
