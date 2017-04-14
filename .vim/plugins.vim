set nocompatible
filetype plugin indent on
filetype off

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

Plugin 'neomake/neomake'

Plugin 'kchmck/vim-coffee-script'
Plugin 'chriskempson/base16-vim'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'tpope/vim-commentary'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'zchee/deoplete-go'
Plugin 'Shougo/deoplete.nvim'
Plugin 'tpope/vim-endwise'
Plugin 'bogado/file-line'
Plugin 'tpope/vim-fugitive'
Plugin 'henrik/git-grep-vim'
Plugin 'garyburd/go-explorer'
Plugin 'pangloss/vim-javascript'
Plugin 'kassio/neoterm'
Plugin 'powerline/powerline'
Plugin 'neovim/python-client'
Plugin 'tpope/vim-rails'
Plugin 'vim-ruby/vim-ruby'
Plugin 'wting/rust.vim'
Plugin 'tsaleh/vim-supertab'
Plugin 'tpope/vim-surround'
Plugin 'scrooloose/syntastic'
Plugin 'godlygeek/tabular'
Plugin 'majutsushi/tagbar'
Plugin 'edkolev/tmuxline.vim'
Plugin 'jgdavey/tslime.vim'
Plugin 'slashmili/alchemist.vim'
Plugin 'ryanoasis/vim-devicons'
Plugin 'jodosha/vim-devnotes'
Plugin 'tpope/vim-dispatch'
Plugin 'elixir-lang/vim-elixir'
Plugin 'isRuslan/vim-es6'
Plugin 'junegunn/vim-github-dashboard'
Plugin 'fatih/vim-go'
Plugin 'jodosha/vim-godebug'
Plugin 'henrik/vim-qargs'
Plugin 'kennethzfeng/vim-raml'
Plugin 'hwartig/vim-seeing-is-believing'
Plugin 'slim-template/vim-slim'
Plugin 'jgdavey/vim-turbux'

call vundle#end()            " required
filetype plugin indent on    " required
