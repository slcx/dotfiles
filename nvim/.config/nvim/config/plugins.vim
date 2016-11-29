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
else
  set statusline=%f\ %m%y%r%w%=%l/%L\ %P\ %{ALEGetStatusLine()}\ 
endif

" colors
Plug 'AlessandroYorba/Despacio'
Plug '0ax1/lxvc'
Plug 'robertmeta/nofrils'
Plug 'dracula/vim'
Plug 'junegunn/seoul256.vim'
Plug 'baskerville/bubblegum'
Plug 'Soares/base16.nvim'
Plug 'atelierbram/Base2Tone-vim'

if has('nvim')
  " ale
  Plug 'w0rp/ale'

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

" autocmd
au BufRead,BufNewFile *.cson set ft=coffee

call plug#end()
