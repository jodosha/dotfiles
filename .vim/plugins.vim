set nocompatible
filetype plugin indent on
filetype off

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

Plugin 'tpope/vim-commentary'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'Shougo/deoplete.nvim'
Plugin 'bogado/file-line'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-rhubarb'
Plugin 'janko-m/vim-test'
Plugin 'scrooloose/syntastic'
Plugin 'majutsushi/tagbar'
Plugin 'chriskempson/base16-vim'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'ryanoasis/vim-devicons'
Plugin 'jodosha/vim-devnotes'
Plugin 'zchee/deoplete-go'
Plugin 'sovetnik/vim-hanami'
Plugin 'tpope/vim-rails'
Plugin 'vim-ruby/vim-ruby'
Plugin 'edkolev/tmuxline.vim' " ???
Plugin 'fatih/vim-go'
Plugin 'jodosha/vim-godebug'
Plugin 'kchmck/vim-coffee-script'
Plugin 'slim-template/vim-slim.git'
Plugin 'jparise/vim-graphql'
Plugin 'pechorin/any-jump.vim'
Plugin 'tyru/open-browser.vim' " Needed by plantuml-previewer
Plugin 'aklt/plantuml-syntax'
Plugin 'weirongxu/plantuml-previewer.vim'
Plugin 'dracula/vim', { 'as': 'dracula' }

call vundle#end()            " required
filetype plugin indent on    " required
filetype plugin on           " required by wimwiki
