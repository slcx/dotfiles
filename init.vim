"    ,    /-.
"   ((___/ __>
"   /      }
"   \ .--.(    ___
"jgs \\   \\  /___\

set mouse=a
set autowrite
set noswapfile
set nowritebackup
set hidden
set number
set inccommand=nosplit
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

" --- plugin config
let g:ale_javascript_eslint_executable = expand('~/.npm/bin/eslint')
let g:prettier#exec_cmd_path = "~/.yarn/bin/prettier"
let g:prettier#nvim_unstable_async=1
let g:prettier#exec_cmd_async = 1
let g:prettier#quickfix_enabled = 0
let g:prettier#autoformat = 0

" --- plugins
call plug#begin('~/.local/share/nvim/plugged')
Plug 'junegunn/vim-easy-align'
Plug 'tpope/vim-commentary'
Plug 'prettier/vim-prettier', { 'do': 'yarn install' }
" linters
Plug 'w0rp/ale'
" aesthetics
Plug 'morhetz/gruvbox'
Plug 'rhysd/vim-color-spring-night'
" language support
Plug 'rust-lang/rust.vim'
Plug 'fatih/vim-go'
Plug 'othree/yajs.vim'
Plug 'othree/es.next.syntax.vim'
Plug 'reasonml-editor/vim-reason-plus'
call plug#end()

" --- colors
set termguicolors
set background=dark
colorscheme spring-night

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
autocmd BufNewFile,BufRead *.go \
  setlocal tabstop=4 softtabstop=4 shiftwidth=4 noexpandtab
autocmd TermOpen * setlocal nonumber
autocmd BufWritePre,TextChanged,InsertLeave *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.md,*.vue PrettierAsync
