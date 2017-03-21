"  _       _ _         _
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

" autocomplete plugin(s)
let s:auto = 0

" bare configuration -- no plugins
let s:bare = 0

if !has("nvim")
  " we are not on neovim, assume a bare configuration
  let s:bare = 1
endif

" general
set mouse=a
set list                            " display invisibles
set listchars=tab:▸\  " list
set number                          " line numbers
set numberwidth=5                   " line number width
set cpoptions+=n
set foldmethod=marker               " fold by marker
set virtualedit=block
set ignorecase                      " insensitive searching
set smartcase                       " smart searching
set timeoutlen=180                  " key timeout
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
set emoji                           " emoji support
set laststatus=2                    " show status bar
set shortmess+=I                    " minimal
set statusline=%f\ %m%y%r%w%=%l/%L\ %P\  " hand-crafted status
set nowritebackup                   " messes with fs.watch
set hidden
set completeopt=menu
set colorcolumn=80

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
  " auto plug install
  if empty(glob('~/.config/nvim/autoload/plug.vim'))
    silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
      \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
  endif

  " plug
  call plug#begin('~/.config/nvim/plugged')

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

  " aesthetics
  let g:airline_powerline_fonts = 1
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  set noshowmode

  if s:lite == 0
    if s:auto
      Plug 'Valloric/YouCompleteMe', { 'do': './install.py' }
    else
      Plug 'Shougo/deoplete.nvim'
      let g:deoplete#enable_at_startup = 1
      Plug 'zchee/deoplete-jedi'
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
  Plug 'chriskempson/base16-vim'
  Plug 'nanotech/jellybeans.vim'
  Plug 'AlessandroYorba/Monrovia'
  Plug 'joshdick/onedark.vim'
  Plug 'romainl/Apprentice', { 'branch': 'fancylines-and-neovim' }

  call plug#end()
endif

" cursor shape
let $NVIM_TUI_ENABLE_CURSOR_SHAPE=2

" incommand -- preview your substitution before you even hit enter
if exists("&inccommand") && has("nvim")
  set inccommand=nosplit
endif

" colors
set background=dark
set t_Co=256

" apply our current colorscheme
try
  colorscheme apprentice
catch /^Vim\%((\a\+)\)\=:E185/
  colorscheme desert
endtry

" terminal gui colors
" we only apply this if our terminal is suckless ;)
if ($TERM =~ "st" || $TERM =~ "rxvt" || $TERM =~ "xterm-256color")
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

" rg with fzf
let g:rg_command = '
  \ rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --color "always"
  \ -g "*.{js,json,php,md,styl,jade,html,config,py,cpp,c,go,hs,rb,conf}"
  \ -g "!*.{min.js,swp,o,zip,pyc}"
  \ -g "!{.git,node_modules,bower_modules,__pycache__,vendor}/*" '

command! -bang -nargs=* F call fzf#vim#grep(g:rg_command .shellescape(<q-args>), 1, <bang>0)

" autocmd
augroup filetypes
  autocmd!
  autocmd BufRead,BufNewFile *.cson set ft=coffee
augroup END

fun! <SID>AutoMakeDirectory()
  let s:directory = expand("<afile>:p:h")
  if !isdirectory(s:directory)
    call mkdir(s:directory, "p")
  endif
endfun

fun! <SID>HTMLAbbreviations()
  " html entity abbreviations
  iabbrev <buffer> * &Star;
  iabbrev <buffer> -> &rarr;
  iabbrev <buffer> <- &larr;
  iabbrev <buffer> != &ne;
  iabbrev <buffer> <= &le;
  iabbrev <buffer> >= &ge;
  iabbrev <buffer> >> &Gt;
  iabbrev <buffer> << &Lt;
  inoremap <buffer> -- &mdash;
endfun

" automatically make directories if you
" :e use/directories/that/dont/exist/test.c
augroup easywrite
  autocmd!
  autocmd! BufWritePre,FileWritePre * :call <SID>AutoMakeDirectory()
augroup END

" html helpers
augroup htmlutilities
  autocmd!
  autocmd FileType html setlocal spell
  autocmd FileType html :call <SID>HTMLAbbreviations()
augroup END

function! s:fzf_statusline()
  hi! link fzf1 Comment
  hi! link fzf2 Comment
  hi! link fzf3 Comment
  setlocal statusline=%#fzf1#\ %#fzf2#fz%#fzf3#f
endfunction

augroup fzf
  autocmd!
  autocmd! User FzfStatusLine call <SID>fzf_statusline()
augroup END

" maps
let mapleader="\<Space>"

" quick escape
" i have since binded caps lock to escape.
" inoremap jk <esc>
" inoremap <esc> <nop>

" hide statusbar
nnoremap <silent> <leader>p :set laststatus=1<cr>

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
let $FZF_DEFAULT_COMMAND='rg --files --hidden --follow'
nnoremap <silent> <C-K> :F<CR>
nnoremap <silent> <C-P> :Files<CR>
nnoremap <silent> <C-O> :Buffers<CR>

" buffer navigation
nnoremap <silent> <A-[> :bp<CR>
nnoremap <silent> <A-]> :bn<CR>

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

" hl
hi! ColorColumn guibg=#333333
