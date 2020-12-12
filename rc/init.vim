" vim: ts=8:sts=2:sw=2:fdm=marker
" slice's neovim config (>^_^>)

set colorcolumn=80,120
set completeopt=menu,noselect
set cursorline
set hidden
set ignorecase
set inccommand=nosplit
set list
set listchars=tab:→\ ,trail:·,nbsp:+
set modeline
set mouse=a
set noswapfile
set nowrap
set nowritebackup
set number
set scrolloff=5
set shortmess+=I
set signcolumn=yes
set smartcase
set statusline=%f\ %r\ %m%=%l/%L,%c\ (%P)
set undodir=$HOME/.local/share/nvim/undo
set undofile

if exists('&pumblend')
  set pumblend=10
endif

set expandtab
set tabstop=8
set softtabstop=2
set shiftwidth=2

if exists('neovim_dot_app') " rogual/neovim-dot-app
  call MacSetFont('PragmataPro Mono', 14)
endif

set guifont=PragmataPro\ Mono:h14
set linespace=2

" source local config
if filereadable(expand('~/.config/nvim/local.vim'))
  source ~/.config/nvim/local.vim
endif

" plugin settings {{{

let g:seoul256_background = 236
let g:scala_scaladoc_indent = 1

let g:neoformat_enabled_python = ['black']
let g:neoformat_python_black =
\ { 'exe': 'black',
  \ 'stdin': 1,
  \ 'args': ['--fast', '--target-version', 'py38', '-q', '-'] }

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

" }}}

" plugins {{{

call plug#begin('~/.local/share/nvim/plugged')

Plug 'justinmk/vim-dirvish'                     " improved builtin file browser
Plug 'justinmk/vim-gtfo'                        " gof opens gui file manager
Plug 'junegunn/vim-easy-align'                  " text alignment
Plug 'tpope/vim-scriptease'                     " utilities for vim scripts
Plug 'tpope/vim-eunuch'                         " vim sugar for unix shell commands
Plug 'tpope/vim-commentary'                     " good comment editing
Plug 'tpope/vim-unimpaired'                     " pairs of handy bracket mappings
Plug 'tpope/vim-surround'                       " easily edit surrounding characters
Plug 'tpope/vim-fugitive'                       " delightful git wrapper
Plug 'tpope/vim-repeat'                         " . works on more stuff
Plug 'sbdchd/neoformat'                         " asynchronous formatting
Plug 'zirrostig/vim-schlepp'                    " nudge lines around
Plug 'junegunn/vim-peekaboo'                    " peekaboo the registers
Plug 'mhinz/vim-sayonara', { 'on': 'Sayonara' } " better :bd

" Plug 'https://gitlab.com/code-stats/code-stats-vim.git'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } } " fuzzy finder
Plug 'junegunn/fzf.vim'                             " fuzzy finder vim integration

Plug 'w0rp/ale'              " asynchronous linter
Plug 'neovim/nvim-lspconfig' " neovim lsp integration

" colorschemes
Plug 'junegunn/seoul256.vim'
Plug 'romainl/Apprentice'
Plug 'nanotech/jellybeans.vim'
Plug 'jnurmine/Zenburn'
Plug 'wadackel/vim-dogrun'
Plug 'bluz71/vim-moonfly-colors'

" language support
Plug 'Vimjas/vim-python-pep8-indent' " better python indentation rules
Plug 'ziglang/zig.vim'
Plug 'derekwyatt/vim-scala'
Plug 'rhysd/vim-crystal'
Plug 'wavded/vim-stylus'
Plug 'rust-lang/rust.vim'
Plug 'fatih/vim-go'
Plug 'pangloss/vim-javascript'
Plug 'HerringtonDarkholme/yats.vim'  " typescript
Plug 'MaxMEllon/vim-jsx-pretty'      " jsx
Plug 'neovimhaskell/haskell-vim'
Plug 'keith/swift.vim'

call plug#end()

" }}}

" colors {{{

" prefer 24-bit color codes if possible
if has('termguicolors')
  set termguicolors
endif

set background=dark

try
  colorscheme zenburn
catch E185
  colorscheme desert
endtry

if g:colors_name ==? "zenburn"
  highlight! link Whitespace NonText
endif

" }}}

" maps and abbrevs {{{

let g:mapleader = ' '

" use shift+tab to go back; complements tab
nnoremap <S-Tab> <C-O>

" fzf
nmap <silent> <leader>o <cmd>Files<CR>
nmap <silent> <leader>b <cmd>Buffers<CR>

" vimrc
nmap <silent> <leader>ev <cmd>edit $MYVIMRC<CR>
nmap <silent> <leader>sv <cmd>source $MYVIMRC<CR>

" plug
nmap <silent> <leader>pi <cmd>PlugInstall<CR>
nmap <silent> <leader>pu <cmd>PlugUpdate<CR>
nmap <silent> <leader>pg <cmd>PlugUpgrade<CR>

" plugins
nmap <silent> <leader>nf <cmd>Neoformat<CR>
xmap <silent> ga         <Plug>(EasyAlign)
nmap <silent> ga         <Plug>(EasyAlign)
vmap <silent> <up>       <Plug>SchleppIndentUp
vmap <silent> <down>     <Plug>SchleppIndentDown
vmap <silent> <left>     <Plug>SchleppLeft
vmap <silent> <right>    <Plug>SchleppRight

" buffers, etc.
nmap <silent> <C-L> <cmd>nohlsearch<CR>
nmap <silent> <A-[> <cmd>bprevious<CR>
nmap <silent> <A-]> <cmd>bnext<CR>

" the option key on the default keyboard layout of macos acts as a compose key
" for certain symbols, so let's add these as mappings in case the terminal
" can't resolve them correctly
nmap <silent> ‘ <cmd>bnext<CR>
nmap <silent> “ <cmd>bprevious<CR>

" Q enters ex mode by default, so let's bind it to gq so it's more useful
noremap Q gq

" use sayonara
cnoremap bd Sayonara!

" a neat trick to write files with sudo
cnoremap w!! write !sudo tee % >/dev/null

" sometimes i hold shift down for too long
cabbrev W w
cabbrev Wq wq
cabbrev Qa qa
cabbrev Bd bd

" allow using :diffput and :diffget in visual mode
" (can't use d* because d means delete)
vnoremap fp :'<,'>diffput<CR>
vnoremap fg :'<,'>diffget<CR>

" }}}

" autocmd {{{

augroup language_settings
  autocmd!
  autocmd BufNewFile,BufReadPre *.go
    \ setlocal tabstop=4 softtabstop=4 shiftwidth=4 noexpandtab
  autocmd BufNewFile,BufReadPre *.sass,*.scss
    \ setlocal softtabstop=2 shiftwidth=2 expandtab
  autocmd BufNewFile,BufReadPre *.sc,*.sbt
    \ setlocal filetype=scala
augroup END

augroup terminal_numbers
  autocmd!
  autocmd TermOpen * setlocal nonumber norelativenumber
augroup END

augroup autoformatting
  autocmd!
  autocmd BufWritePre *.js,*.css,*.html,*.yml silent! undojoin | Neoformat
augroup END

" }}}

" linting & lsp {{{

hi ALEVirtualTextError guibg=#aa0000 guifg=#ffffff

let g:ale_enabled = 1
let g:ale_set_quickfix = 1
let g:ale_echo_msg_format = '%linter%(%severity%): %[code] %%s'
" let g:ale_javascript_eslint_executable = expand('~/.npm/bin/eslint')
" let g:ale_typescript_tslint_executable = expand('~/.npm/bin/tslint')
let g:ale_virtualtext_cursor = 1
let g:ale_linters = {
  \ 'scss': ['stylelint'],
  \ 'sass': ['stylelint'],
  \ 'python': ['flake8', 'mypy'],
  \ }

nnoremap <silent> <leader>lf <cmd>lua vim.lsp.buf.formatting()<CR>

nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gd    <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
" map <silent> K  <cmd>call LanguageClient#textDocument_hover()<CR>
" map <silent> gd <cmd>call LanguageClient#textDocument_definition()<CR>
" map <silent> gr <cmd>call LanguageClient#textDocument_rename()<CR>

augroup lsp
  autocmd!
  " autocmd Filetype python,rust setlocal formatexpr=LanguageClient#textDocument_rangeFormatting_sync()
  autocmd Filetype python,rust,scala setlocal omnifunc=v:lua.vim.lsp.omnifunc
  " autocmd BufWritePre *.py,*.rs,*.scala lua vim.lsp.buf.formatting()
  " autocmd BufWritePre *.py,*.rs call LanguageClient#textDocument_formatting_sync()
  autocmd BufWritePre *.py,*.rs Neoformat
  autocmd Filetype typescript,typescriptreact ALEDisableBuffer
augroup END

let g:metals_server_version = '0.8.4+140-a39ac728-SNAPSHOT'

lua << EOF
local lsp = require'lspconfig'

lsp.metals.setup{
  cmd = {'/Users/slice/.coursier-bin/metals'}
}
-- lsp.tsserver.setup{}
-- lsp.rust_analyzer.setup{}
lsp.pyls.setup{
  root_dir = lsp.util.root_pattern('setup.py', 'requirements.txt'),
  settings = {
    pyls = { plugins = {
      pydocstyle = { enabled = false },
      pycodestyle = { enabled = false },
      pyflakes = { enabled = false },
      pyls_mypy = { enabled = false, live_mode = false }
    } }
  }
}
EOF

" }}}
