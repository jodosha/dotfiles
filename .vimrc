source ~/.vim/plugins.vim

set nocompatible     " Vim behavior, not Vi.
set encoding=utf-8   " Use UTF-8 encoding
set nobackup         " Don't backup
set nowritebackup    " Write file in place
set noswapfile       " Don't use swap files (.swp)
set autoread         " Autoreload buffers
set autowrite        " Automatically save changes before switching buffers
syntax enable        " Enable syntax highlight
syntax on            " Syntax on for wimwiki

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
let base16colorspace=256
set background=dark
set guifont=InconsolataForPowerline\ Nerd\ Font\ Medium:h18
set linespace=2
set visualbell
colorscheme base16-eighties
let g:airline_theme='base16_ocean'
let g:airline_powerline_fonts = 1
let g:tmuxline_theme='base16_ocean'

if !has('nvim')
  set antialias
endif

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
endif

" Splits
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Buffers
map <leader>bd :bufdo bdelete<cr>

" ctags
map <silent> <Leader>rt :!retag<cr>
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

" Demo
function! ReadDemoingSlideInformations()
  let g:demoing_file_name = str2nr(expand("%:r"))
  let g:demoing_file_type = "." . expand("%:e")
endfunction

function! LoadDemoingSlide()
  execute "edit " . g:demoing_file_name . g:demoing_file_type
endfunction

function! NextDemoingSlide()
  call ReadDemoingSlideInformations()
  let g:demoing_file_name += 1
  call LoadDemoingSlide()
endfunction

function! PreviousDemoingSlide()
  call ReadDemoingSlideInformations()
  let g:demoing_file_name -= 1
  call LoadDemoingSlide()
endfunction

map <F4> :call NextDemoingSlide()<CR>
map <F3> :call PreviousDemoingSlide()<CR>

function! Carousel()
  for theme in split(globpath(&runtimepath, 'colors/*.vim'), '\n')
    let t = fnamemodify(theme, ':t:r')
    try
      execute 'colorscheme '.t
      echo t
    catch
    finally
    endtry
    sleep 4
    redraw
  endfor
endfunction

map <silent> <Leader>tc :call Carousel()<cr>

" The Silver Searcher
" Inspired by http://robots.thoughtbot.com/faster-grepping-in-vim/
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor\ --path-to-ignore\ $HOME/.agignore

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

nmap <silent> <leader>re :TestNearest<CR>
nmap <silent> <leader>r :TestFile<CR>
nmap <silent> <leader>rr :TestSuite<CR>

" Ruby
let g:syntastic_ruby_checkers = ['rubocop', 'mri']

" Automatically fold comments in Ruby files
autocmd FileType ruby,eruby
       \ set foldmethod=expr |
       \ set foldexpr=getline(v:lnum)=~'^\\s*#'

function! RubocopAutocorrect()
  execute "!rubocop -a " . bufname("%")
  call SyntasticCheck()
endfunction

map <silent> <Leader>cop :call RubocopAutocorrect()<cr>

" Go
let g:python3_host_prog = '/usr/local/bin/python3'

let g:syntastic_go_checkers = ['go', 'govet', 'golint', 'errcheck']
let g:syntastic_mode_map = { 'mode': 'active', 'passive_filetypes': ['go'] }

let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_fields = 1
let g:go_highlight_types = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1

let g:deoplete#enable_at_startup = 1

"" Run Go
au FileType go nmap <leader>r <Plug>(go-run)
au FileType go nmap <leader>b <Plug>(go-build)
au FileType go nmap <leader>t <Plug>(go-test)
au FileType go nmap <leader>c <Plug>(go-coverage)

au FileType go nmap <leader>rt <Plug>(go-run-tab)
au FileType go nmap <Leader>rs <Plug>(go-run-split)
au FileType go nmap <Leader>rv <Plug>(go-run-vertical)

"" Go docs
au FileType go nmap <leader>ds <Plug>(go-def-split)
au FileType go nmap <leader>dv <Plug>(go-def-vertical)
au FileType go nmap <leader>dt <Plug>(go-def-tab)

au FileType go nmap <leader>gd <Plug>(go-doc)
au FileType go nmap <leader>gv <Plug>(go-doc-vertical)

au FileType go nmap <leader>gb <Plug>(go-doc-browser)

"" Go types
au FileType go nmap <leader>s <Plug>(go-implements)
au FileType go nmap <leader>i <Plug>(go-info)

let g:go_term_mode = "split"
let g:go_term_enabled = 1
let g:go_fmt_command = "goimports"
