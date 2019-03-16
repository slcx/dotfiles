" ryan's (neo)vimrc

set autowrite
set colorcolumn=80,120
set hidden
set ignorecase
set inccommand=nosplit
set list
set listchars=tab:▸\ ,eol:\ ,trail:.,nbsp:+
set mouse=a
set noswapfile
set nowrap
set nowritebackup
set number
set scrolloff=3
set smartcase
set undodir=$HOME/.config/nvim/undo
set undofile
set undolevels=1000
set undoreload=10000

set expandtab
set tabstop=8
set softtabstop=2
set shiftwidth=2

" --- plugin config
let g:ale_javascript_eslint_executable = expand('~/.npm/bin/eslint')
let g:ale_typescript_tslint_executable = expand('~/.npm/bin/tslint')
let g:seoul256_background = 236

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

" source local config
if filereadable(expand('~/.config/nvim/local.nvim'))
  source ~/.config/nvim/local.vim
endif

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

" language support
Plug 'rhysd/vim-crystal'
Plug 'leafgarland/typescript-vim'
Plug 'wavded/vim-stylus'
Plug 'rust-lang/rust.vim'
Plug 'fatih/vim-go'
Plug 'othree/yajs.vim'
Plug 'mxw/vim-jsx'
Plug 'othree/es.next.syntax.vim'
call plug#end()

" --- colors
if has('termguicolors')
  set termguicolors
endif

set background=dark

try
  colorscheme seoul256
catch E185
  colorscheme desert
endtry

" --- maps and abbrevs
let g:mapleader = ' '
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

" macos's default keyboard layout's option key outputs special characters
" when the option key is held, and macos's alt key is option
nnoremap <silent> ‘ :bn<CR>
nnoremap <silent> “ :bp<CR>

cnoreabbrev W w
cnoreabbrev Wq wq
cnoreabbrev Qa qa

" --- autocmd
autocmd BufNewFile,BufRead *.go
  \ setlocal tabstop=4 softtabstop=5 shiftwidth=4 noexpandtab
autocmd BufNewFile,BufRead *.sass,*.scss
  \ setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab

autocmd TermOpen * setlocal nonumber
