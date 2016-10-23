" this is my minimal vimrc.

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
set undodir=$HOME/.vim/undo " undo dir
set undolevels=1000         " undo levels
set undoreload=10000        " number of lines to save for undo

if v:version >= 800
	set belloff=all           " disable bells
	set breakindent           " break indentation
	set emoji                 " emojis
	set fixeol                " restore eol at newline
endif

" Strip the newline from the end of a string
function! Chomp(str)
  return substitute(a:str, '\n$', '', '')
endfunction

" Find a file and pass it to cmd
function! DmenuOpen(cmd)
  let fname = Chomp(system("git ls-files | dmenu -i -l 20 -fn PragmataPro -p " . a:cmd))
  if empty(fname)
    return
  endif
  execute a:cmd . " " . fname
endfunction

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

" variables
let g:togglecursor_force = 'xterm'

" plug
call plug#begin('~/.vim/plugged')

" syntaxes
Plug 'rf-/vaxe'
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

" misc
set runtimepath+=~/.vim/snippets        " snippets
Plug 'jszakmeister/vim-togglecursor'    " nice looking cursor in insert mode
Plug 'justinmk/vim-dirvish'             " nice file browser
Plug 'junegunn/vim-easy-align'          " easy aligning
Plug 'tpope/vim-sensible'               " sensible defaults
Plug 'tpope/vim-commentary'             " comment stuff out
Plug 'tpope/vim-endwise'                " autoinsert end keywords
Plug 'SirVer/ultisnips'                 " snippets
Plug 'honza/vim-snippets'               " snippets
Plug 'ervandew/supertab'                " tab for completion
Plug 'scrooloose/nerdtree'              " nerdtree
Plug 'mhinz/vim-startify'               " nice start screen

let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

" colors
Plug 'AlessandroYorba/Despacio'

if has('nvim')
	" neomake
	Plug 'neomake/neomake'
	autocmd! BufWritePost * Neomake

	" deoplete
	Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
	let g:deoplete#omni_patterns = {}
	let g:deoplete#omni_patterns.haxe = '[^. *\t]\.\w*'
	let g:deoplete#auto_complete_delay = 10
	let g:deoplete#enable_at_startup = 1
else
	" syntastic
	Plug 'maralla/validator.vim'

	let g:validator_javascript_checkers = ['eslint']
	let g:validator_error_msg_format = "[ ● %d/%d issues ]"
endif

call plug#end()

" maps
let mapleader="\<Space>"

xmap ga <Plug>(LiveEasyAlign)
nmap ga <Plug>(LiveEasyAlign)
map <c-t> :call DmenuOpen("tabe")<cr>

" colors
set background=dark
set t_Co=256

" terminal gui colors
" we only apply this if our terminal is suckless ;)
if ($TERM =~ "st") && (v:version >= 800 || has('nvim'))
	set termguicolors

	" if we are on regular vim, fix broken colors
	if !has('nvim')
		set t_8f=[38;2;%lu;%lu;%lum
		set t_8b=[48;2;%lu;%lu;%lum
	endif
endif

color despacio

hi! Comment gui=NONE
hi! Todo gui=NONE
hi! link SpecialKey NonText
