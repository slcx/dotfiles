" ryan's (neo)vimrc

if !has('nvim')
  " recreate neovim's sane defaults
  set ruler
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
  set nrformats=bin,hex
  set sessionoptions-=options
  set smarttab
  set tabpagemax=50
  set tags=./tags;,tags
  set ttyfast
  set viminfo+=!
  set wildmenu
  set sessionoptions-=options
  set belloff=all
else
  " neovim exclusives
  set inccommand=nosplit
endif

set list
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
set iskeyword-=_ " _ breaks words

" --- plugin config
let g:ale_javascript_eslint_executable = expand('~/.npm/bin/eslint')
let g:ale_typescript_tslint_executable = expand('~/.npm/bin/tslint')

" --- plugins
call plug#begin('~/.local/share/nvim/plugged')
Plug 'justinmk/vim-dirvish'
Plug 'junegunn/vim-easy-align'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-surround'
Plug 'reedes/vim-pencil'
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
" linters
Plug 'w0rp/ale'
" colors
Plug 'morhetz/gruvbox'
Plug 'rhysd/vim-color-spring-night'
Plug 'junegunn/seoul256.vim'
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

let s:font_default_columnspace = -1
let s:font_default_linespace = 3
let s:font_default_profile = "prag-s"
let s:font_profiles = {
  \ "prag": "PragmataPro Mono:h18",
  \ "prag-s": "PragmataPro Mono:h14",
  \ "fira-s": "Fira Code:h13",
  \ "fira": "Fira Code:h17",
  \ "input": "Input Mono Narrow:h17",
  \ "input-xs": ["Input Mono Narrow:h13", -1, -2],
  \ "iosevka": "Iosevka Term:h18",
\ }

function! s:FontProfileCompl(ArgLead, CmdLine, CursorPos)
  return keys(s:font_profiles)
endfunction

function! s:SwitchFontProfile(profile)
  try
    let l:profile = s:font_profiles[a:profile]
    if type(l:profile) ==# v:t_list
      let &guifont = l:profile[0]
      let &columnspace = get(l:profile, 1, s:font_default_columnspace)
      let &linespace = get(l:profile, 2, s:font_default_linespace)
    else
      let &guifont = l:profile
      let &columnspace = s:font_default_columnspace
      let &linespace = s:font_default_linespace
    endif
  catch E716
    echoe "Font profile \"".a:profile."\" not found."
  endtry
endfunction
command! -nargs=1 -complete=customlist,s:FontProfileCompl
  \ Font call s:SwitchFontProfile(<f-args>)

" --- gui
if has("gui_macvim")
  " hide scrollbars
  set guioptions=

  " character options/spacing
  let &columnspace=s:font_default_columnspace
  let &linespace=s:font_default_linespace
  set macligatures

  call s:SwitchFontProfile(s:font_default_profile)
endif

" --- colors
if has('termguicolors')
  set termguicolors
endif
set background=dark
try
  colorscheme gruvbox
catch E185
  colorscheme desert
endtry

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
autocmd BufNewFile,BufRead *.go
  \ setlocal tabstop=4 softtabstop=4 shiftwidth=4 noexpandtab
autocmd BufNewFile,BufRead *.sass,*.scss
  \ setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
autocmd FileType markdown,md,text call pencil#init()

if has('nvim')
  autocmd TermOpen * setlocal nonumber
endif
