"    ,    /-.
"   ((___/ __>
"   /      }
"   \ .--.(    ___
"jgs \\   \\  /___\

if !has('nvim')
  " recreate neovim's sane defaults
  set autoindent
  set autoread
  set backspace=indent,eol,start
  set complete-=i
  set display=lastline
  set encoding=utf-8
  set formatoptions=tcqj
  set history=10000
  set hlsearch
  set incsearch
  set langnoremap
  set laststatus=2
  set listchars=tab:>\ ,trail:-,nbsp:+
  set nrformats=hex
  set sessionoptions-=options
  set smarttab
  set tabpagemax=50
  set tags=./tags;,tags
  set ttyfast
  set viminfo+=!
  set wildmenu
else
  " neovim exclusives
  set inccommand=nosplit
endif

set mouse=a
set autowrite
set noswapfile
set nowritebackup
set hidden
set number
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

" --- plugin config
let g:ale_javascript_eslint_executable = expand('~/.npm/bin/eslint')
let g:ale_typescript_tslint_executable = expand('~/.npm/bin/tslint')

" --- plugins
call plug#begin('~/.local/share/nvim/plugged')
Plug 'justinmk/vim-dirvish'
Plug 'junegunn/vim-easy-align'
Plug 'tpope/vim-commentary'
Plug 'reedes/vim-pencil'
" linters
Plug 'w0rp/ale'
" aesthetics
Plug 'morhetz/gruvbox'
Plug 'rhysd/vim-color-spring-night'
" language support
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
call plug#end()

" --- colors
if has('termguicolors')
  set termguicolors
endif
set background=dark
colorscheme spring-night

" --- maps
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
autocmd BufNewFile,BufRead *.go setlocal tabstop=4 softtabstop=4 shiftwidth=4 noexpandtab
autocmd BufNewFile,BufRead *.sass,*.scss setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
autocmd FileType markdown,md,text call pencil#init()

if has('nvim')
  autocmd TermOpen * setlocal nonumber
endif
