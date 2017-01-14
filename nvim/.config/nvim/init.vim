 " _       _ _         _           
" (_)_ __ (_) |___   _(_)_ __ ___  
" | | '_ \| | __\ \ / / | '_ ` _ \ 
" | | | | | | |_ \ V /| | | | | | |
" |_|_| |_|_|\__(_)_/ |_|_| |_| |_|
"
" this is ryan's init.vim (~/.vimrc)!
"
" while this configuration is vim compatible, plugins
" will only be applied on neovim.
                                 
" light configuration -- no heavy plugins
" only applicable if s:bare is 0
let s:lite = 0

" bare configuration -- no plugins
let s:bare = 0

if !has("nvim")
  " we are not on neovim, assume a bare configuration
  let s:bare = 1
endif

" general
set list                            " display invisibles
set listchars=tab:▸\ 
set number                          " line numbers
set numberwidth=5                   " line number width
set cpoptions+=n
set foldmethod=marker               " fold by marker
set virtualedit=block
set ignorecase                      " insensitive searching
set smartcase                       " smart searching
set timeoutlen=180                  " key timeout
set writebackup                     " enable write backups
set noswapfile                      " disable swap files
set history=500                     " command history
set modeline                        " modeline
set autowrite
set fileencodings=utf-8             " utf-8 please
set undofile                        " persistent undo
set undodir=$HOME/.config/nvim/undo " undo dir
set undolevels=1000                 " undo levels
set undoreload=10000                " lines to save for undo
set belloff=all                     " disable bells
set breakindent                     " break indentation
set emoji
set cursorline

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
  " neovim has sane defaults which are activated automatically.
  " since we aren't in neovim, activate sane defaults
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

if !s:bare
  " plug
  call plug#begin('~/.config/nvim/plugged')

  " syntaxes
  Plug 'othree/html5.vim'                 " enhanced html5 syntax
  Plug 'hail2u/vim-css3-syntax'           " enhanced css3 syntax
  Plug 'lepture/vim-jinja'                " jinja syntax
  Plug 'othree/yajs.vim'
  Plug 'othree/javascript-libraries-syntax.vim'
  Plug 'othree/es.next.syntax.vim'
  Plug 'rschmukler/pangloss-vim-indent'
  let g:jsx_ext_required = 0
  Plug 'mxw/vim-jsx'
  Plug 'kchmck/vim-coffee-script'         " coffeescript syntax
  Plug 'leafo/moonscript-vim'             " moonscript syntax
  Plug 'octol/vim-cpp-enhanced-highlight' " enhanced c++ syntax
  Plug 'evanmiller/nginx-vim-syntax'      " nginx
  Plug 'rhysd/vim-crystal'                " vim
  Plug 'leafgarland/typescript-vim'       " typescript
  Plug 'cespare/vim-toml'                 " toml
  Plug 'rust-lang/rust.vim'               " rust
  Plug 'fatih/vim-go'                     " golang
  Plug 'posva/vim-vue'

  " misc
  Plug 'justinmk/vim-dirvish'             " nice file browser
  Plug 'junegunn/vim-easy-align'          " easy aligning
  Plug 'tpope/vim-commentary'             " comment stuff out
  Plug 'tpope/vim-endwise'                " autoinsert end keywords
  Plug 'ervandew/supertab'                " tab for completion

  if s:lite == 0
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' } " deoplete
    let g:deoplete#enable_at_startup = 1

    Plug 'w0rp/ale'
    set statusline=%f\ %m%y%r%w%=%l/%L\ %P\ 

    " Customize fzf colors to match your color scheme
    let g:fzf_files_options =
      \ '--preview "head -'.&lines.' {}"'
    let g:fzf_colors =
    \ { "fg":      ["fg", "Normal"],
      \ "bg":      ["bg", "Normal"],
      \ "hl":      ["fg", "Comment"],
      \ "fg+":     ["fg", "CursorLine", "CursorColumn", "Normal"],
      \ "bg+":     ["bg", "CursorLine", "CursorColumn"],
      \ "hl+":     ["fg", "Statement"],
      \ "info":    ["fg", "PreProc"],
      \ "prompt":  ["fg", "Conditional"],
      \ "pointer": ["fg", "Exception"],
      \ "marker":  ["fg", "Keyword"],
      \ "spinner": ["fg", "Label"],
      \ "header":  ["fg", "Comment"] }

    " do not tie fzf to the shell
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
    Plug 'junegunn/fzf.vim'
  endif

  " colors
  Plug 'chriskempson/base16-vim'
  Plug 'nanotech/jellybeans.vim'

  call plug#end()
endif

" cursor shape
let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1

" incommand -- preview your substitution before you even hit enter
if exists("&inccommand") && has("nvim")
  set inccommand=nosplit
endif

" colors
set background=dark
set t_Co=256

" apply our current colorscheme
try
  let g:jellybeans_use_gui_italics = 0
  colorscheme base16-atelier-plateau
catch /^Vim\%((\a\+)\)\=:E185/
  colorscheme desert
endtry

" terminal gui colors
" we only apply this if our terminal is suckless ;)
if ($TERM =~ "st" || $TERM =~ "rxvt")
  " seoul looks better without terminal gui colors
  if g:colors_name != "seoul256"
    set termguicolors
  endif

  " if we are on regular vim, fix broken colors because neovim did it right
  if !has("nvim")
    set t_8f=[38;2;%lu;%lu;%lum
    set t_8b=[48;2;%lu;%lu;%lum
  endif
endif

" opinionated syntax highlighting fixes
hi! link SpecialKey NonText

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

fun! <SID>HTMLAbbreviations()
  " html entity abbreviations
  :iabbrev <buffer> * &Star;
  :iabbrev <buffer> -> &rarr;
  :iabbrev <buffer> <- &larr;
  :iabbrev <buffer> != &ne;
  :iabbrev <buffer> <= &le;
  :iabbrev <buffer> >= &ge;
  :iabbrev <buffer> >> &Gt;
  :iabbrev <buffer> << &Lt;
  :inoremap <buffer> -- &mdash;
endfun

" automatically make directories if you
" :tabe use/directories/that/dont/exist/test.c
autocmd BufWritePre,FileWritePre * :call <SID>AutoMakeDirectory()

" html helpers
autocmd FileType html setlocal spell
autocmd FileType html :call <SID>HTMLAbbreviations()

" maps
let mapleader="\<Space>"

" quick escape
inoremap jk <esc>
inoremap <esc> <nop>

" plug
nnoremap <leader>pi :PlugInstall<cr>
nnoremap <leader>pu :PlugUpdate<cr>
nnoremap <leader>pg :PlugUpgrade<cr>

" easy align
xnoremap ga <plug>(LiveEasyAlign)
nnoremap ga <plug>(LiveEasyAlign)

" clear highlight
nnoremap <silent> <C-L> :noh<CR>

" fzf
nnoremap <silent> <C-K> :Ag<CR>
nnoremap <silent> <C-P> :Files<CR>

" disable arrow keys
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>

" utilities
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>
