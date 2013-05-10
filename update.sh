#!/bin/sh

set -e
DOTFILES_ROOT="$HOME/.dotfiles"

ln_s () {
  ln -sfn "$DOTFILES_ROOT/$1" "$2"
}

echo "Fetching changes from remote repository"
  git pull origin master

echo "Fetching changes from submodules"
  git submodule init
  git submodule update

echo "Updating user defined scripts"
  rm ~/bin/*
  ls bin | while read script; do ln_s "bin/$script" ~/bin; done

echo "Reloading the shell"
  exec $SHELL
