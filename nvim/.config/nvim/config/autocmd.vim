" autocmd
au BufRead,BufNewFile *.cson set ft=coffee

fun! <SID>AutoMakeDirectory()
  let s:directory = expand("<afile>:p:h")
  if !isdirectory(s:directory)
    call mkdir(s:directory, "p")
  endif
endfun

" automatically make directories
autocmd BufWritePre,FileWritePre * :call <SID>AutoMakeDirectory()
