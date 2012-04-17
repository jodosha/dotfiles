set nocompatible     " Vim behavior, not Vi.
set encoding=utf-8   " Use UTF-8 encoding
set nobackup         " Don't backup
set nowritebackup    " Write file in place
set noswapfile       " Don't use swap files (.swp)
set autoread         " Autoreload buffers
syntax enable        " Enable syntax highlight

" pathogen
call pathogen#infect()
filetype plugin indent on

" History, Cursor, Rulers
set history=50    " Just remember last 50 commands
set laststatus=2  " Always display the status line
set ruler         " Show the cursor position all the time
set number        " Show line numbers
set showcmd       " Display incomplete commands
set cursorline    " Highlight current cursor line
set showcmd       " Display incomplete commands
set shell=zsh     " Default shell is ZSH

" Tabs and white spaces
set nowrap                        " Don't wrap lines
set tabstop=2                     " Tabs are always 2 spaces
set expandtab                     " Expand tabs into spaces
set shiftwidth=2                  " Reindent with 2 spaces (using <<)
set list                          " Show invisible chars
set listchars=""                  " Reset listchars
set list listchars=tab:»·,trail:· " Set listchars for tabs and trailing spaces

" Search
set hlsearch    " Highlight matches
set incsearch   " Incremental searching
set ignorecase  " Searches are case insensitive...
set smartcase   " ... unless they contain at least one capital letter

" Apparence
colorscheme Tomorrow-Night   " Tomorrow Night is the theme of choice
set guifont=Menlo\ bold:h14  " Font is Menlo
set linespace=2
set antialias
set visualbell

set guioptions-=T            " Hide the Vim toolbar
set guioptions-=r            " Hide the Vim scrollbars

if has('gui_running')
  set transparency=5         " A bit of transparency
endif

" ctags
" map <Leader>rt :!ctags --extra=+f --exclude=.git --exclude=log -R * `gem environment gemdir`/gems/*<CR><CR>
map <silent> <Leader>rt :!bundle list --paths=true \| xargs ctags --extra=+f --exclude=.git --exclude=log -R *<CR><CR>

" Remove highlight after search
nmap <silent> <C-N> :silent noh<CR>

" Quick switch between numbers ruler
noremap <silent> <F12> :set number!<CR>

" Force using hjkl, not arrows
nnoremap <Left> :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up> :echoe "Use k"<CR>
nnoremap <Down> :echoe "Use j"<CR>
