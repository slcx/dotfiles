" ryan's (neo)vimrc

set autowrite
set colorcolumn=80,120
set expandtab
set hidden
set ignorecase
set inccommand=nosplit
set iskeyword-=_ " _ breaks words
set list
set mouse=a
set noswapfile
set nowritebackup
set number
set scrolloff=3
set shiftwidth=2
set smartcase
set softtabstop=2
set tabstop=2
set undodir=$HOME/.config/nvim/undo
set undofile
set undolevels=1000
set undoreload=10000

" --- plugin config
let g:ale_javascript_eslint_executable = expand('~/.npm/bin/eslint')
let g:ale_typescript_tslint_executable = expand('~/.npm/bin/tslint')

" source local config
source ~/.config/nvim/local.vim

" --- plugins
call plug#begin('~/.local/share/nvim/plugged')
Plug 'justinmk/vim-dirvish'
Plug 'junegunn/vim-easy-align'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'godlygeek/tabular'
" Plug 'https://gitlab.com/code-stats/code-stats-vim.git'

" linters
Plug 'w0rp/ale'

" colors
Plug 'nightsense/snow'
Plug 'morhetz/gruvbox'
Plug 'junegunn/seoul256.vim'
Plug 'owickstrom/vim-colors-paramount'
Plug 'robertmeta/nofrils'

" language support
Plug 'rhysd/vim-crystal'
Plug 'leafgarland/typescript-vim'
Plug 'wavded/vim-stylus'
Plug 'rust-lang/rust.vim'
Plug 'fatih/vim-go'
Plug 'othree/yajs.vim'
Plug 'mxw/vim-jsx'
Plug 'othree/es.next.syntax.vim'
Plug 'reasonml-editor/vim-reason-plus'
Plug 'posva/vim-vue'
Plug 'wavded/vim-stylus'
Plug 'leafo/moonscript-vim'
call plug#end()

" --- colors
if has('termguicolors')
  set termguicolors
endif

set background=dark

try
  colorscheme paramount
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
" when the option key is held, and macos's alt key is option -- account for
" that here
nnoremap <silent> ‘ :bn<CR>
nnoremap <silent> “ :bp<CR>

cnoreabbrev W w
cnoreabbrev Wq wq
cnoreabbrev Qa qa

" --- autocmd
autocmd BufNewFile,BufRead *.go
  \ setlocal tabstop=4 softtabstop=4 shiftwidth=4 noexpandtab
autocmd BufNewFile,BufRead *.sass,*.scss
  \ setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab

autocmd TermOpen * setlocal nonumber
