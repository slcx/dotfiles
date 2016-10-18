" this is my minimal vimrc.

" general
set list                    " display invisibles
set listchars=tab:▸\ ,eol:¬ " invisible chars
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
                            " set smartindent
set smarttab
set fileencodings=utf-8     " utf-8 please

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
set noexpandtab " tabs please

if has('gui_running')
	" in gvim
	set guifont=PragmataPro\ 13.5
	set guiheadroom=0
	set guioptions=
endif

" variables
let g:togglecursor_force = 'xterm'

" plug
call plug#begin('~/.vim/plugged')

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
	let g:deoplete#enable_at_startup = 1

	" supertab
	Plug 'ervandew/supertab'
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
