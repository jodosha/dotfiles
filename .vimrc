call plug#begin(has('nvim') ? stdpath('data') . '/plugged' : '~/.vim/plugged')
  " Theme
  Plug 'chriskempson/base16-vim'
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  Plug 'ryanoasis/vim-devicons'
  Plug 'dracula/vim', { 'as': 'dracula' }

  " Testing
  Plug 'janko-m/vim-test'

  " Git(Hub)
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-rhubarb'

  " LSP
  Plug 'neovim/nvim-lspconfig'
  Plug 'williamboman/nvim-lsp-installer'
  Plug 'hrsh7th/cmp-nvim-lsp'
  Plug 'hrsh7th/cmp-buffer'
  Plug 'hrsh7th/cmp-path'
  Plug 'hrsh7th/cmp-cmdline'
  Plug 'folke/trouble.nvim'

  " Autocomplete
  Plug 'hrsh7th/nvim-cmp'
  Plug 'hrsh7th/cmp-vsnip'
  Plug 'hrsh7th/vim-vsnip'

  " Fuzzy search
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  Plug 'nvim-telescope/telescope.nvim'
  Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
  Plug 'nvim-telescope/telescope-file-browser.nvim'

  " Languages
  Plug 'vim-ruby/vim-ruby'
  Plug 'fatih/vim-go'

  " Misc
  Plug 'kyazdani42/nvim-web-devicons'
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-surround'
call plug#end()

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
set termguicolors
colorscheme base16-dracula
let g:airline_theme='dracula'
let g:airline_powerline_fonts = 1
let g:airline#extensions#nvimlsp#enabled = 1
let g:airline#extensions#nvimlsp#error_symbol = 'E'
let g:airline#extensions#nvimlsp#warning_symbol = 'W'
let g:tmuxline_theme='base16_dracula'

if filereadable(expand("~/.vimrc_background"))
  let base16colorspace=256
  source ~/.vimrc_background
endif

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
nmap <silent> <leader>rs :TestSuite<CR>
nnoremap <leader>tr <cmd>TroubleToggle<cr>

" Ruby
if has('nvim')
  " Run Ruby script in NeoVim terminal emulator
  map <Leader>rr :w<CR>:split \| terminal ruby %<CR>:startinsert<CR>
endif

" Automatically fold comments in Ruby files
autocmd FileType ruby,eruby
       \ set foldmethod=expr |
       \ set foldexpr=getline(v:lnum)=~'^\\s*#'

function! RubocopAutocorrect()
  execute "!rubocop -a " . bufname("%")
endfunction

map <silent> <Leader>cop :call RubocopAutocorrect()<cr>

" From: https://shime.sh/til/writing-custom-vim-template
" Automatically add frozen string literal to the header of Ruby files.
function! RubyTemplate()
    " Add pragma comment
    call setline(1, '# frozen_string_literal: true')
    " Add two empty lines
    call append(1, repeat([''], 2))
    " Place cursor on line number 3
    call cursor(3, 0)
    " Write file to refresh the buffer
    execute "w"
endfunction
autocmd BufNewFile *.rb :call RubyTemplate()

function! FormatJSON()
  execute "%!python -m json.tool"
endfunction
map <silent> <Leader>json :call FormatJSON()<cr>

" Coc
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<Tab>" :
      \ coc#refresh()

" Go
let g:python3_host_prog = '/usr/local/bin/python3'

let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_fields = 1
let g:go_highlight_types = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1

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

lua << EOF
  require'lspconfig'.solargraph.setup{}
  require'lspconfig'.gopls.setup{}
  require'lspconfig'.eslint.setup{}
  require'lspconfig'.tsserver.setup{}

  local opts = { noremap=true, silent=true }
  vim.api.nvim_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  vim.api.nvim_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  vim.api.nvim_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  vim.api.nvim_set_keymap('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)

  -- Use an on_attach function to only map the following keys
  -- after the language server attaches to the current buffer
  local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
end

  -- Use a loop to conveniently call 'setup' on multiple servers and
  -- map buffer local keybindings when the language server attaches
  local servers = { 'solargraph', 'gopls', 'eslint', 'tsserver' }
  for _, lsp in pairs(servers) do
    require('lspconfig')[lsp].setup {
      on_attach = on_attach,
      flags = {
        -- This will be the default in neovim 0.7+
        debounce_text_changes = 150,
        }
      }
  end

  -- Setup nvim-lsp-installer
  local lsp_installer = require("nvim-lsp-installer")

  -- Setup nvim-cmp.
  local cmp = require'cmp'

  cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body)
      end,
    },
    mapping = {
      ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
      ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
      ['<C-n>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
      ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
      ['<C-e>'] = cmp.mapping({
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
      }),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    },
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
    }, {
      { name = 'buffer' },
    })
  })

  require('telescope').setup({
    pickers = {
      find_files = {
        theme = "dropdown",
      }
    },
  })

  require('telescope').load_extension('fzf')
  require("telescope").load_extension "file_browser"
EOF

nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

