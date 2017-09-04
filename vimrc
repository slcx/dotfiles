" ryan's vimrc
scriptencoding utf8

" gui settings {{{
set guifont=SF\ Mono:h12
set linespace=2
" }}}

" general settings {{{
set mouse=a
set listchars=tab:▸\ ,eol:¬
set autoindent
set smartindent
set laststatus=2
set number
set hlsearch
set wildmenu
set ignorecase
set smartcase
set noswapfile
set ruler
set foldmethod=marker
set incsearch
set hidden
" }}}

" indentation settings {{{
set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2
" }}}

" plugins {{{
call plug#begin('~/.vim/plugged')

" colorschemes
Plug 'junegunn/seoul256.vim'
Plug 'chriskempson/base16-vim'

" lint
Plug 'w0rp/ale'

" lang
Plug 'rust-lang/rust.vim'
Plug 'leafgarland/typescript-vim'
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'

" edit
Plug 'junegunn/vim-easy-align'
Plug 'junegunn/vim-peekaboo'
Plug 'junegunn/vim-slash'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-unimpaired'
Plug 'scrooloose/nerdtree'

" settings {{{
" easyalign
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

" allow jsx in .js files
let g:jsx_ext_required = 0
" }}}

call plug#end()
" }}}

" mappings {{{
nmap <silent> <C-N> :noh<CR>

" leader
let g:mapleader = "\<Space>"

nnoremap <silent> <leader>pi :PlugInstall<CR>
" updates plugins
nnoremap <silent> <leader>pu :PlugUpdate<CR>
" updates plug itself
nnoremap <silent> <leader>pg :PlugUpgrade<CR>

nnoremap <silent> <leader>sv :source ~/.vimrc<CR>
nnoremap <silent> <leader>ev :edit ~/.vimrc<CR>
" }}}

" colorscheme
colorscheme seoul256-light
