" colors
set background=dark
set t_Co=256

" apply our current colorscheme
colorscheme base16-atelier-estuary

" terminal gui colors
" we only apply this if our terminal is suckless ;)
if ($TERM =~ "st" || $TERM =~ "rxvt") && (v:version >= 800 || has('nvim'))
  " seoul looks better without terminal gui colors
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
hi! link SpecialKey NonText
