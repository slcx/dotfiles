let g:lite = 1
let g:fzf = 1

" general
"set list                   " display invisibles
"set listchars=tab:▸\ ,eol:¬" invisible chars
set number                  " line numbers
set colorcolumn=80          " color 80 column
set mouse=a                 " mouse support
set hlsearch                " highlight search results
set foldmethod=marker       " fold by marker
set nrformats-=octal        " don't use octal
set virtualedit=block
set ignorecase              " insensitive searching
set smartcase               " sensitive searching when capitals in query
set timeoutlen=200          " key timeout
set writebackup             " enable write backups
set noswapfile              " disable swap files
set history=500             " command history
set modeline                " modeline
set autowrite               " save the file under certain circumstances
set smarttab                " smart TAB button
set fileencodings=utf-8     " utf-8 please
set undofile                " persistent undo
set undodir=$HOME/.config/nvim/undo " undo dir
set undolevels=1000         " undo levels
set undoreload=10000        " number of lines to save for undo
set relativenumber          " relative numbers

if v:version >= 800
	set belloff=all           " disable bells
	set breakindent           " break indentation
	set emoji                 " emojis
	set fixeol                " restore eol at newline
endif

" indentation
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab " spaces please

if has('gui_running')
	" in gvim
	set guifont=PragmataPro\ Mono\ 13.5
	set guiheadroom=0
	set guioptions=
endif

" plug
call plug#begin('~/.config/nvim/plugged')

" plugin config
let g:lightline = {
  \ 'colorscheme': 'seoul256',
  \ 'separator': { 'left': '', 'right': '' },
  \ 'subseparator': { 'left': '', 'right': '' } }
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
let g:seoul256_background = 236

" syntaxes
Plug 'othree/html5.vim'                 " enhanced html5 syntax
Plug 'hail2u/vim-css3-syntax'           " enhanced css3 syntax
Plug 'lepture/vim-jinja'                " jinja syntax
Plug 'fasterthanlime/ooc.vim'           " ooc syntax
Plug 'pangloss/vim-javascript'          " enhanced javascript syntax
Plug 'mxw/vim-jsx'                      " jsx syntax
let g:jsx_ext_required = 0
Plug 'kchmck/vim-coffee-script'         " coffeescript syntax
Plug 'leafo/moonscript-vim'             " moonscript syntax
Plug 'octol/vim-cpp-enhanced-highlight' " enhanced c++ syntax
Plug 'evanmiller/nginx-vim-syntax'      " nginx
Plug 'rhysd/vim-crystal'                " vim

" misc
set runtimepath+=~/.config/nvim/snippets
Plug 'justinmk/vim-dirvish'             " nice file browser
Plug 'junegunn/vim-easy-align'          " easy aligning
Plug 'tpope/vim-sensible'               " sensible defaults
Plug 'tpope/vim-commentary'             " comment stuff out
Plug 'tpope/vim-endwise'                " autoinsert end keywords
Plug 'ervandew/supertab'                " tab for completion
Plug 'scrooloose/nerdtree'              " nerdtree
Plug 'tpope/vim-fugitive'               " git stuff 

if g:lite == 0
  Plug 'itchyny/lightline.vim'            " powerline :O
  Plug 'SirVer/ultisnips'                 " snippets
  Plug 'honza/vim-snippets'               " snippets
endif

if g:fzf == 1
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
  Plug 'junegunn/fzf.vim'
  let g:fzf_layout = { 'down': '~60%' }
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
endif

" colors
Plug 'AlessandroYorba/Despacio'
Plug '0ax1/lxvc'
Plug 'robertmeta/nofrils'
Plug 'chriskempson/base16-vim'
Plug 'dracula/vim'
Plug 'junegunn/seoul256.vim'
Plug 'baskerville/bubblegum'

" autocmd
au BufRead,BufNewFile *.cson set ft=coffee

if has('nvim')
	" neomake
	Plug 'neomake/neomake'
	autocmd! BufWritePost * Neomake

  let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1
else
	" syntastic
	Plug 'maralla/validator.vim'

	let g:validator_javascript_checkers = ['eslint']
	let g:validator_error_msg_format = "[ ● %d/%d issues ]"

  let g:togglecursor_force = "xterm"
  let g:togglecursor_disable_neovim = 1
  Plug 'jszakmeister/vim-togglecursor' " toggle cursor
endif

call plug#end()

" maps
let mapleader="\<Space>"

xmap ga <plug>(LiveEasyAlign)
nmap ga <plug>(LiveEasyAlign)
nmap <silent> <c-p> :Files<cr>

" colors
set background=dark
set t_Co=256

colorscheme bubblegum-256-dark

" terminal gui colors
" we only apply this if our terminal is suckless ;)
if ($TERM =~ "st" || $TERM =~ "rxvt") && (v:version >= 800 || has('nvim'))
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
hi! Comment gui=NONE
hi! Todo gui=NONE
hi! link SpecialKey NonText

if exists("&inccommand") && has("nvim")
  set inccommand=nosplit
endif
