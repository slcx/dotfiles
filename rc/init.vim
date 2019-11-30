" slice's neovim config

set autowrite
set colorcolumn=80,120
set hidden
set ignorecase
set inccommand=nosplit
set list
set listchars=tab:→\ ,eol:\ ,trail:·,nbsp:+
set mouse=a
set modeline
set noswapfile
set nowrap
set nowritebackup
set number
set scrolloff=3
set smartcase
set undodir=$HOME/.local/share/nvim/undo
set undofile

if has('pumblend')
  set pumblend=15
endif

set expandtab
set tabstop=8
set softtabstop=2
set shiftwidth=2

set guifont=PragmataPro\ Mono:h14
set linespace=3

" --- plugin config
let g:ale_echo_msg_format = '%linter%(%severity%): %[code] %%s'
let g:ale_javascript_eslint_executable = expand('~/.npm/bin/eslint')
let g:ale_typescript_tslint_executable = expand('~/.npm/bin/tslint')
let g:seoul256_background = 236
let g:scala_scaladoc_indent = 1

let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

" --- plugins
call plug#begin('~/.local/share/nvim/plugged')
Plug 'justinmk/vim-dirvish'
Plug 'junegunn/vim-easy-align'
Plug 'junegunn/vim-slash'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'godlygeek/tabular'
Plug 'sbdchd/neoformat'
" Plug 'junegunn/vim-peekaboo'
" Plug 'tpope/vim-vinegar'
" Plug 'https://gitlab.com/code-stats/code-stats-vim.git'

if isdirectory("/usr/local/opt/fzf")
  Plug '/usr/local/opt/fzf'
  Plug 'junegunn/fzf.vim'
endif

" linters
Plug 'w0rp/ale'

" colors
Plug 'junegunn/seoul256.vim'
Plug 'romainl/Apprentice'
Plug 'nanotech/jellybeans.vim'
Plug 'jnurmine/Zenburn'

" language support
Plug 'derekwyatt/vim-scala'
Plug 'rhysd/vim-crystal'
Plug 'leafgarland/typescript-vim'
Plug 'wavded/vim-stylus'
Plug 'rust-lang/rust.vim'
Plug 'fatih/vim-go'
Plug 'pangloss/vim-javascript'
Plug 'MaxMEllon/vim-jsx-pretty'

call plug#end()

" source local config
if filereadable(expand('~/.config/nvim/local.vim'))
  source ~/.config/nvim/local.vim
endif

" --- colors
if has('termguicolors')
  set termguicolors
endif

set background=dark

try
  colorscheme zenburn
catch E185
  colorscheme desert
endtry

" --- maps and abbrevs
let g:mapleader = ' '

" fzf
nmap <silent> <leader>o :Files<CR>
nmap <silent> <leader>b :Buffers<CR>

" vimrc
nmap <silent> <leader>ev :edit $MYVIMRC<CR>
nmap <silent> <leader>sv :source $MYVIMRC<CR>

" plug
nmap <silent> <leader>pi :PlugInstall<CR>
nmap <silent> <leader>pu :PlugUpdate<CR>
nmap <silent> <leader>pg :PlugUpgrade<CR>

" plugins
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

" buffers, etc.
nmap <silent> <C-L> :nohlsearch<CR>
nmap <silent> <A-[> :bprevious<CR>
nmap <silent> <A-]> :bnext<CR>
" the option key on the default keyboard layout of macos acts as a compose key
" for certain symbols, so let's add these as mappings in case the terminal
" can't resolve them correctly
nmap <silent> ‘ :bnext<CR>
nmap <silent> “ :bprevious<CR>

" a neat trick to write files with sudo
cnoremap w!! write !sudo tee % >/dev/null

" sometimes i hold shift down for too long
cabbrev W w
cabbrev Wq wq
cabbrev Qa qa

" --- autocmd
augroup language_settings
  autocmd!
  autocmd BufNewFile,BufRead *.go
    \ setlocal tabstop=4 softtabstop=4 shiftwidth=4 noexpandtab
  autocmd BufNewFile,BufRead *.sass,*.scss
    \ setlocal softtabstop=2 shiftwidth=2 expandtab
  autocmd BufNewFile,BufRead *.sc,*.sbt
    \ setlocal filetype=scala
augroup END

augroup terminal_numbers
  autocmd!
  autocmd TermOpen * setlocal nonumber
augroup END
