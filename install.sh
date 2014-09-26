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
  /usr/bin/ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
  brew doctor
  brew update

echo "Installing GCC"
  brew tap homebrew/versions
  brew install gcc49
  brew install libtool libyaml libksba

echo "Installing OpenSSL"
  brew install openssl

echo "Installing GPG"
  brew install gpg

echo "Installing Git"
  brew install git
  brew install git-flow

echo "Installing Exuberant Tags"
  brew install ctags-exuberant

echo "Installing The Silver Searcher"
  brew install the_silver_searcher
  ln_s .agignore .

echo "Installing Tmux"
  brew install tmux

echo "Installing Vim"
  curl ftp://ftp.vim.org/pub/vim/unix/vim-7.4.tar.bz2 | tar -xz
  cd vim73 && ./configure --with-features=huge --enable-cscope --enable-rubyinterp=dynamic --enable-multibyte && make && sudo make install
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

echo "Installing Keybase"
  npm install -g keybase-installer
  keybase-installer

echo "Installing Chruby"
  brew install chruby
  ln_s .ruby-version .

echo "Installing ruby-install"
  brew install ruby-install

echo "Cloning dotfiles repo"
  rm -rf ~/.dotfiles
  git clone git@github.com:jodosha/dotfiles.git ~/.dotfiles

echo "Installing Oh-My-ZSH"
  git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
  ln_s jodosha.zsh-theme .oh-my-zsh/themes
  ln_s .zshrc .
  [[ -f /etc/zprofile ]] || sudo mv /etc/zshenv /etc/zprofile
  chsh -s /bin/zsh

echo "Configuring Tmux"
  ln_s .tmux.conf .

echo "Configuring Git"
  ln_s .gitconfig .
  ln_s gitignore .gitignore

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

echo "Installing Ruby"
  install_ruby

echo "** Configuring RubyGems.org account"
  mkdir -p ~/.gem
  curl -u jodosha https://rubygems.org/api/v1/api_key.yaml > ~/.gem/credentials

echo "** Configuring Heroku account"
  curl https://toolbelt.heroku.com/install.sh | sh
  heroku login

echo "Reloading the shell"
  exec $SHELL -l
