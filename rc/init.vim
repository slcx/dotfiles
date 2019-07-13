" slice's neovim config

set autowrite
set colorcolumn=80,120
set hidden
set ignorecase
set inccommand=nosplit
set list
set listchars=tab:→\ ,eol:\ ,trail:·,nbsp:+
set mouse=a
set noswapfile
set nowrap
set nowritebackup
set number
set scrolloff=3
set smartcase
set undodir=$HOME/.local/share/nvim/undo
set undofile
set pumblend=15

set expandtab
set tabstop=8
set softtabstop=2
set shiftwidth=2

" --- plugin config
let g:ale_echo_msg_format = '%linter%(%severity%): %[code] %%s'
let g:ale_javascript_eslint_executable = expand('~/.npm/bin/eslint')
let g:ale_typescript_tslint_executable = expand('~/.npm/bin/tslint')
let g:seoul256_background = 236
let g:scala_scaladoc_indent = 1

let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

" --- plugins
call plug#begin('~/.local/share/nvim/plugged')
Plug 'justinmk/vim-dirvish'
Plug 'junegunn/vim-easy-align'
Plug 'junegunn/vim-slash'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'godlygeek/tabular'
Plug 'sbdchd/neoformat'
" Plug 'tpope/vim-vinegar'
" Plug 'https://gitlab.com/code-stats/code-stats-vim.git'

if isdirectory("/usr/local/opt/fzf")
  Plug '/usr/local/opt/fzf'
  Plug 'junegunn/fzf.vim'
endif

" linters
Plug 'w0rp/ale'

" colors
Plug 'junegunn/seoul256.vim'
Plug 'chriskempson/base16-vim'
Plug 'romainl/Apprentice'
Plug 'nanotech/jellybeans.vim'

" language support
Plug 'derekwyatt/vim-scala'
Plug 'rhysd/vim-crystal'
Plug 'leafgarland/typescript-vim'
Plug 'wavded/vim-stylus'
Plug 'rust-lang/rust.vim'
Plug 'fatih/vim-go'
Plug 'othree/yajs.vim'
Plug 'mxw/vim-jsx'
Plug 'othree/es.next.syntax.vim'

call plug#end()

" source local config
if filereadable(expand('~/.config/nvim/local.vim'))
  source ~/.config/nvim/local.vim
endif

" --- colors
if has('termguicolors')
  set termguicolors
endif

set background=dark

try
  colorscheme apprentice
catch E185
  colorscheme desert
endtry

" --- maps and abbrevs
let g:mapleader = ' '
nnoremap <silent> <leader>o :Files<CR>
nnoremap <silent> <leader>ev :e $MYVIMRC<CR>
nnoremap <silent> <leader>pi :PlugInstall<CR>
nnoremap <silent> <leader>pu :PlugUpdate<CR>
nnoremap <silent> <leader>pg :PlugUpgrade<CR>
nnoremap <silent> <leader>sv :source $MYVIMRC<CR>
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)
nnoremap <silent> <C-L> :noh<CR>
nnoremap <silent> <A-[> :bp<CR>
nnoremap <silent> <A-]> :bn<CR>
" the option key on the default keyboard layout of macos acts as a compose key
" for certain symbols, so let's add these as mappings in case the terminal
" can't resolve them correctly
nnoremap <silent> ‘ :bn<CR>
nnoremap <silent> “ :bp<CR>

cnoreabbrev W w
cnoreabbrev Wq wq
cnoreabbrev Qa qa

" --- autocmd

augroup language_settings
  autocmd!
  autocmd BufNewFile,BufRead *.go
    \ setlocal tabstop=4 softtabstop=4 shiftwidth=4 noexpandtab
  autocmd BufNewFile,BufRead *.sass,*.scss
    \ setlocal softtabstop=2 shiftwidth=2 expandtab
  autocmd BufNewFile,BufRead *.sc,*.sbt
    \ setlocal filetype=scala
augroup END

augroup terminal_numbers
  autocmd!
  autocmd TermOpen * setlocal nonumber
augroup END

if g:colors_name ==# "apprentice"
  let g:terminal_color_0  = "#1C1C1C"
  let g:terminal_color_1  = "#AF5F5F"
  let g:terminal_color_10 = "#87AF87"
  let g:terminal_color_11 = "#FFFFAF"
  let g:terminal_color_12 = "#8FAFD7"
  let g:terminal_color_13 = "#8787AF"
  let g:terminal_color_14 = "#5FAFAF"
  let g:terminal_color_15 = "#FFFFFF"
  let g:terminal_color_2  = "#5F875F"
  let g:terminal_color_3  = "#87875F"
  let g:terminal_color_4  = "#5F87AF"
  let g:terminal_color_5  = "#5F5F87"
  let g:terminal_color_6  = "#5F8787"
  let g:terminal_color_7  = "#6C6C6C"
  let g:terminal_color_8  = "#444444"
  let g:terminal_color_9  = "#FF8700"
endif
