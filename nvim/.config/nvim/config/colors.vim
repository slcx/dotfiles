" colors
set background=dark
set t_Co=256

colorscheme bubblegum-256-dark

" terminal gui colors
" we only apply this if our terminal is suckless ;)
if ($TERM =~ "st" || $TERM =~ "rxvt") && (v:version >= 800 || has('nvim'))
  if g:colors_name != "seoul256"
    set termguicolors
  endif

  " if we are on regular vim, fix broken colors because neovim
  " did it right
  if !has('nvim')
    set t_8f=[38;2;%lu;%lu;%lum
    set t_8b=[48;2;%lu;%lu;%lum
  endif
endif

" opinionated syntax highlighting fixes
hi! Comment gui=NONE
hi! Todo gui=NONE
hi! link SpecialKey NonText
