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
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' } " deoplete
  let g:deoplete#enable_at_startup = 1
else
  set statusline=%f\ %m%y%r%w%=%l/%L\ %P\ %{ALEGetStatusLine()}\ 
endif

" colors
Plug 'chriskempson/base16-vim'

" ale
Plug 'w0rp/ale'

" cursor shape
let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1

call plug#end()
