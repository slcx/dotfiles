scriptencoding utf-8

set backspace=indent,eol,start
set mouse=a
set hidden
set wildmenu
set autowrite
set noswapfile
set nowritebackup
set shortmess+=I
set laststatus=2
set number

" searching
set incsearch
set ignorecase
set smartcase

" undo saving
set undofile
set undodir=$HOME/.config/nvim/undo
set undolevels=1000
set undoreload=10000

" indentation
set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2

let s:bare = 0
let s:lite = 0
let s:auto = 1

if !s:bare
  " automatically install plug
  if empty(glob('~/.config/nvim/autoload/plug.vim'))
    " install plug.vim
    silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
      \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    augroup InitialPlugInstall
      autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
    augroup END
  endif

  " plug
  call plug#begin('~/.config/nvim/plug')

  " plugin configuration
  let g:jsx_ext_required = 0
  let g:peekaboo_delay = 250
  let g:peekaboo_window = 'vertical botright 30new'

  " additional language support
  Plug 'othree/html5.vim'
  Plug 'hail2u/vim-css3-syntax'
  Plug 'lepture/vim-jinja'
  Plug 'othree/yajs.vim'
  Plug 'othree/javascript-libraries-syntax.vim'
  Plug 'othree/es.next.syntax.vim'
  let g:jsx_ext_required = 0
  Plug 'mxw/vim-jsx'
  Plug 'kchmck/vim-coffee-script'
  Plug 'leafo/moonscript-vim'
  Plug 'octol/vim-cpp-enhanced-highlight'
  Plug 'evanmiller/nginx-vim-syntax'
  Plug 'rhysd/vim-crystal'
  Plug 'leafgarland/typescript-vim'
  Plug 'cespare/vim-toml'
  Plug 'rust-lang/rust.vim'
  Plug 'fatih/vim-go'
  Plug 'posva/vim-vue'
  Plug 'Vimjas/vim-python-pep8-indent'

  " utilities
  Plug 'tpope/vim-fugitive'
  Plug 'justinmk/vim-dirvish'
  Plug 'junegunn/vim-easy-align'
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-endwise', { 'for': ['vim', 'ruby'] }
  Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
  Plug 'junegunn/vim-peekaboo'
  Plug 'tpope/vim-surround'
  Plug 'junegunn/vim-slash'

  if s:lite == 0
    if s:auto && has('nvim')
      Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
      let g:deoplete#enable_at_startup = 1
    else
      Plug 'ervandew/supertab'
    endif

    Plug 'w0rp/ale'

    " fzf options
    let g:fzf_layout = { 'down': '~70%' }
    let g:fzf_files_options =
      \ '--preview "head -'.&lines.' {}"'
    let g:fzf_colors =
    \ { 'fg':      ['fg', 'Normal'],
      \ 'bg':      ['bg', 'Normal'],
      \ 'hl':      ['fg', 'Comment'],
      \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
      \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
      \ 'hl+':     ['fg', 'Statement'],
      \ 'info':    ['fg', 'PreProc'],
      \ 'prompt':  ['fg', 'Conditional'],
      \ 'pointer': ['fg', 'Exception'],
      \ 'marker':  ['fg', 'Keyword'],
      \ 'spinner': ['fg', 'Label'],
      \ 'header':  ['fg', 'Comment'] }

    " do not tie fzf to the shell
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
    Plug 'junegunn/fzf.vim'
  endif

  " colors
  Plug 'junegunn/seoul256.vim'

  call plug#end()
endif

" ui
set background=dark
set guifont=SF\ Mono:h12
set guioptions=
set termguicolors
syntax enable

try
  colorscheme seoul256
catch
  colorscheme peachpuff
endtry

" maps
let g:mapleader="\<Space>"

" plug
nnoremap <leader>pi :PlugInstall<cr>
nnoremap <leader>pu :PlugUpdate<cr>
nnoremap <leader>pg :PlugUpgrade<cr>
nnoremap <leader>pc :PlugClean<cr>

" easy align
xmap ga <plug>(LiveEasyAlign)
nmap ga <plug>(LiveEasyAlign)

" clear highlight
nnoremap <silent> <C-L> :noh<CR>

" fzf
nnoremap <silent> <C-P> :Files<CR>
nnoremap <silent> <C-O> :Buffers<CR>

" buffer navigation
nnoremap <silent> <A-[> :bp<CR>
nnoremap <silent> <A-]> :bn<CR>
nnoremap <silent> ‘ :bn<CR>
nnoremap <silent> “ :bp<CR>

" disable arrow keys
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>

" utilities
nnoremap <silent> <leader>ev :e $MYVIMRC<cr>
nnoremap <silent> <leader>sv :source $MYVIMRC<cr>

" abbrevs
cnoreabbrev W w
cnoreabbrev Wq wq
