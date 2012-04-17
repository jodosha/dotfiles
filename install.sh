#!/bin/sh

echo "Checking for SSH key, generating one if it doesn't exist"
  [[ -f ~/.ssh/id_rsa.pub ]] || ssh-keygen -t rsa

echo "Copying public key to clipboard. Paste it into your Github account"
  [[ -f ~/.ssh/id_rsa.pub ]] && cat ~/.ssh/id_rsa.pub | pbcopy
  open https://github.com/account/ssh

echo "Installing Homebrew"
  /usr/bin/ruby -e "$(/usr/bin/curl -fksSL https://raw.github.com/mxcl/homebrew/master/Library/Contributions/install_homebrew.rb)"
  brew update

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
  rbenv install 1.9.3-p125
  gem install bundler --no-rdoc --no-ri
  gem install rails   --no-rdoc --no-ri
  gem install heroku  --no-rdoc --no-ri

echo "** Configuring RubyGems.org account"
  mkdir ~/.gem
  curl -u jodosha https://rubygems.org/api/v1/api_key.yaml > ~/.gem/credentials

  rbenv rehash

echo "** Configuring Heroku account"
  heroku account:login

echo "Cloning dotfiles repo"
  rm -rf ~/.dotfiles
  git clone --recursive https://github.com/jodosha/dotfiles.git ~/.dotfiles
  cd ~/.dotfiles

echo "Configuring Oh-My-ZSH"
  cp -R .oh-my-zsh ~/.oh-my-zsh
  cp jodosha.zsh-theme ~/.oh-my-zsh/themes
  cp .zshrc ~/
  chsh -s /bin/zsh

echo "Configuring Tmux"
  cp .tmux.conf ~/

echo "Configuring Git"
  cp -R .gitconfig ~/

echo "Installing user defined scripts"
  cp -R bin ~/

echo "Installing fonts"
  ls fonts | while read font; do open $font; done

echo "Configuring iTerm2"
  open iTerm/Tomorrow\ Night.itermcolors
  cp iTerm/com.googlecode.iterm2.plist ~/Library/Preferences

echo "Configuring Vim"
  cp -R .vim ~/
  cp .vimrc ~/

echo "Cleaning up"
  cd ~
  rm -rf ~/dotfiles

echo "Reloading the shell"
  exec $SHELL
