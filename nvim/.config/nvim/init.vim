let g:lite = 0

let g:bare = 0

if !has('nvim')
  let g:bare = 1
endif

" general
set list                   " display invisibles
set listchars=tab:▸\ 
set number                  " line numbers
set numberwidth=5           " line number width
set cpoptions+=n
set foldmethod=marker       " fold by marker
set virtualedit=block
set ignorecase              " insensitive searching
set smartcase               " sensitive searching when capitals in query
set timeoutlen=200          " key timeout
set writebackup             " enable write backups
set noswapfile              " disable swap files
set history=500             " command history
set modeline                " modeline
set autowrite               " save the file under certain circumstances
set fileencodings=utf-8     " utf-8 please
set undofile                " persistent undo
set undodir=$HOME/.config/nvim/undo " undo dir
set undolevels=1000         " undo levels
set undoreload=10000        " number of lines to save for undo
set belloff=all           " disable bells
set breakindent           " break indentation
set emoji

" indentation
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab

if has('gui_running')
  " in gvim
  set guifont=PragmataPro\ Mono\ 13.5
  set guiheadroom=0
  set guioptions=
endif

if !has('nvim')
  syntax on
  set mouse=a
  set smarttab
  set wildmenu
  set hlsearch
  set incsearch
  set laststatus=2
  set autoindent
  set autoread
  set backspace=2
endif

if !g:bare
  " plug
  call plug#begin('~/.config/nvim/plugged')

  " syntaxes
  Plug 'othree/html5.vim'                 " enhanced html5 syntax
  Plug 'hail2u/vim-css3-syntax'           " enhanced css3 syntax
  Plug 'lepture/vim-jinja'                " jinja syntax
  " javascript {{{
  Plug 'othree/yajs.vim'
  Plug 'othree/javascript-libraries-syntax.vim'
  Plug 'othree/es.next.syntax.vim'
  Plug 'rschmukler/pangloss-vim-indent'
  Plug 'mxw/vim-jsx'
  let g:jsx_ext_required = 0
  " }}}
  Plug 'kchmck/vim-coffee-script'         " coffeescript syntax
  Plug 'leafo/moonscript-vim'             " moonscript syntax
  Plug 'octol/vim-cpp-enhanced-highlight' " enhanced c++ syntax
  Plug 'evanmiller/nginx-vim-syntax'      " nginx
  Plug 'rhysd/vim-crystal'                " vim
  Plug 'leafgarland/typescript-vim'       " typescript
  Plug 'cespare/vim-toml'                 " toml
  Plug 'rust-lang/rust.vim'               " rust
  Plug 'fatih/vim-go'                     " golang

  " misc
  set runtimepath+=~/.config/nvim/snippets
  Plug 'justinmk/vim-dirvish'             " nice file browser
  Plug 'junegunn/vim-easy-align'          " easy aligning
  Plug 'tpope/vim-commentary'             " comment stuff out
  Plug 'tpope/vim-endwise'                " autoinsert end keywords
  Plug 'ervandew/supertab'                " tab for completion

  if g:lite == 0
    " not lite? use deoplete
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' } " deoplete
    let g:deoplete#enable_at_startup = 1
  endif

  " colors
  Plug 'chriskempson/base16-vim'

  if has('nvim')
    " ale
    Plug 'w0rp/ale'
    set statusline=%f\ %m%y%r%w%=%l/%L\ %P\ %{ALEGetStatusLine()}\ 
  endif

  call plug#end()
endif

" cursor shape
let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1

" incommand -- preview your substitution before
" you even hit enter (neovim only)
if exists("&inccommand") && has('nvim')
  set inccommand=nosplit
endif

" colors
set background=dark
set t_Co=256

" apply our current colorscheme
if !g:bare
  colorscheme base16-atelier-estuary
else
  colorscheme desert
endif

" terminal gui colors
" we only apply this if our terminal is suckless ;)
if ($TERM =~ "st" || $TERM =~ "rxvt")
  " seoul looks better without terminal gui colors
  if g:colors_name != "seoul256"
    set termguicolors
  endif

  " if we are on regular vim, fix broken colors because neovim
  " did it right
  if !has('nvim')
    set t_8f=[38;2;%lu;%lu;%lum
    set t_8b=[48;2;%lu;%lu;%lum
  endif
endif

" opinionated syntax highlighting fixes
hi! link SpecialKey NonText
hi! SpecialKey guifg=#48483c

" use w!! to force save
cmap w!! w !sudo tee >/dev/null %

" autocmd
au BufRead,BufNewFile *.cson set ft=coffee

fun! <SID>AutoMakeDirectory()
  let s:directory = expand("<afile>:p:h")
  if !isdirectory(s:directory)
    call mkdir(s:directory, "p")
  endif
endfun

" automatically make directories
autocmd BufWritePre,FileWritePre * :call <SID>AutoMakeDirectory()

" maps
let mapleader="\<Space>"

" easy align
xmap ga <plug>(LiveEasyAlign)
nmap ga <plug>(LiveEasyAlign)

" clear highlight
nmap <silent> <C-L> :noh<CR>

" colors
map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
      \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
      \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>
