let g:lite = 1

" general
set list                   " display invisibles
set listchars=tab:▸\ 
set number                  " line numbers
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
endif

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

source $HOME/.config/nvim/config/plugins.vim
source $HOME/.config/nvim/config/colors.vim
source $HOME/.config/nvim/config/maps.vim

if exists("&inccommand") && has("nvim")
  set inccommand=nosplit
endif
