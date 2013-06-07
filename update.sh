#!/bin/sh

set -e
DOTFILES_ROOT="$HOME/.dotfiles"

ln_s () {
  ln -sfn "$DOTFILES_ROOT/$1" "$2"
}

echo "Fetching changes from remote repository"
  git pull origin master

echo "Updating user defined scripts"
  rm ~/bin/*
  ls bin | while read script; do ln_s "bin/$script" ~/bin; done

echo "Updating Vim plugins"
  upgrade_vim

echo "Reloading the shell"
  exec $SHELL -l
