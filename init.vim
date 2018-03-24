set mouse=a
set autowrite
set noswapfile
set nowritebackup
set hidden
set number
set inccommand=nosplit
set colorcolumn=80,120
set ignorecase
set smartcase
set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2
set undofile
set undodir=$HOME/.config/nvim/undo
set undolevels=1000
set undoreload=10000

call plug#begin('~/.local/share/nvim/plugged')

let g:ale_javascript_eslint_executable = expand('~/.npm/bin/eslint')

" linters
Plug 'w0rp/ale'

" aesthetics
Plug 'morhetz/gruvbox'
Plug 'fenetikm/falcon'

" language support
Plug 'rust-lang/rust.vim'
Plug 'fatih/vim-go'
Plug 'othree/yajs.vim'
Plug 'othree/es.next.syntax.vim'
Plug 'reasonml-editor/vim-reason-plus'

call plug#end()

set termguicolors
set background=light
colorscheme falcon

if g:colors_name == "falcon"
  let g:terminal_color_0 = "#000002"
  let g:terminal_color_1 = "#ff4000"
  let g:terminal_color_10 = "#85a663"
  let g:terminal_color_11 = "#ffd966"
  let g:terminal_color_12 = "#8fa3bf"
  let g:terminal_color_13 = "#ffac59"
  let g:terminal_color_14 = "#85ccc0"
  let g:terminal_color_15 = "#fdfdff"
  let g:terminal_color_2 = "#598033"
  let g:terminal_color_3 = "#ffbf00"
  let g:terminal_color_4 = "#306cbf"
  let g:terminal_color_5 = "#ff8000"
  let g:terminal_color_6 = "#30bfa7"
  let g:terminal_color_7 = "#d4d4d9"
  let g:terminal_color_8 = "#0b0b1a"
  let g:terminal_color_9 = "#ff794c"
  hi! ColorColumn guibg=#0f0f24
endif

let g:mapleader = ' '
nnoremap <silent> <leader>ev :e $MYVIMRC<CR>
nnoremap <silent> <leader>pi :PlugInstall<CR>
nnoremap <silent> <leader>pu :PlugUpdate<CR>
nnoremap <silent> <leader>pg :PlugUpgrade<CR>
nnoremap <silent> <leader>sv :source $MYVIMRC<CR>

nnoremap <silent> <C-L> :noh<CR>
nnoremap <silent> <A-[> :bp<CR>
nnoremap <silent> <A-]> :bn<CR>
" macos's default keyboard layout's option key outputs special characters
" when the option key is held, and macos's alt key is option -- account for
" that here
nnoremap <silent> ‘ :bn<CR>
nnoremap <silent> “ :bp<CR>
cnoreabbrev W w
cnoreabbrev Wq wq
cnoreabbrev Qa qa

autocmd BufNewFile,BufRead *.go setlocal tabstop=4 softtabstop=4 shiftwidth=4 noexpandtab
autocmd TermOpen * setlocal nonumber
