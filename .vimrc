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
set history=50                                                               " Just remember last 50 commands
set laststatus=2                                                             " Always display the status line
set ruler                                                                    " Show the cursor position all the time
set number                                                                   " Show line numbers
set showcmd                                                                  " Display incomplete commands
set cursorline                                                               " Highlight current cursor line
set shell=$SHELL                                                             " Default shell is ZSH
set statusline=%<%f\ %h%m%r%=\ %{devnotes#statusline()}\ %-14.(%l,%c%V%)\ %P " Status line format

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
" colorscheme Tomorrow-Night   " Tomorrow Night is the theme of choice
" Unified color scheme (default: dark)
let g:seoul256_background = 235
colo seoul256
set guifont=Menlo\ bold:h14  " Font is Menlo
set linespace=2
set antialias
set visualbell

set guioptions-=T            " Hide the Vim toolbar
set guioptions-=r            " Hide the Vim scrollbars

if has('gui_running')
  set transparency=5         " A bit of transparency
endif

" highlight the 80th column
"
" In Vim >= 7.3, also highlight columns 120+
if exists('+colorcolumn')
  let &colorcolumn="80,".join(range(120,999),",")
  highlight ColorColumn ctermbg=236
endif

" Splits
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Buffers
map <leader>bd :bufdo bdelete<cr>

" ctags
" map <Leader>rt :!ctags --extra=+f --exclude=.git --exclude=log -R * `gem environment gemdir`/gems/*<CR><CR>
map <silent> <Leader>rt :!bundle list --paths=true \| xargs ctags --extra=+f --exclude=.git --exclude=log -R *<CR><CR>
nmap <F8> :TagbarToggle<CR>

" Remove highlight after search
nmap <silent> <C-N> :silent noh<CR>

" Quick switch between numbers ruler
noremap <silent> <F12> :set number!<CR>

" Open my sharpening tools list (Thanks to Ben Orenstein)
map <Leader>sha :sp ~/Documents/Work/sharp.txt<CR>

" Force using hjkl, not arrows
nnoremap <Left> :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up> :echoe "Use k"<CR>
nnoremap <Down> :echoe "Use j"<CR>

let g:turbux_command_prefix = 'greenbar zeus' "

" Run RSpec examples. Loosely inspired by: https://gist.github.com/1062296
function! RunSpec(args)
  let cmd = "bundle exec rspec " . a:args . " " . @%
  execute ":! echo " . cmd . " && " . cmd
endfunction

map <silent> <leader>r :call RunSpec("") <CR>
map <silent> <leader>re :call RunSpec("-fn -l " . line('.')) <CR>

" Greenbar
function! RunGreenbarTest(file)
  return SendTestToTmux(a:file)
endfunction

function! RunGreenbarFocusedTest(file, line)
  return SendFocusedTestToTmux(a:file, a:line)
endfunction

" Powerline
" let g:tmuxline_powerline_separators = 1
" let g:tmuxline_preset = {
"       \'a'    : '#S',
"       \'b'    : '#W',
"       \'win'  : '#I #W',
"       \'cwin' : '#I #W',
"       \'z'    : '#H'}

" let g:airline_powerline_fonts = 1

" The Silver Searcher
" Inspired by http://robots.thoughtbot.com/faster-grepping-in-vim/
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor\ --path-to-agignore\ $HOME/.agignore

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0

  " bind K to grep word under cursor
  nnoremap K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>

  " bind , (backward slash) to grep shortcut
  command -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!

  nnoremap , :Ag<SPACE>
endif
