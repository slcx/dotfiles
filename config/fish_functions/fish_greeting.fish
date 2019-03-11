function fish_greeting
  set_color brblack
  date +" %A, %B %d, %Y"
  printf ' %s\n' (fortune -s -n 50 computers)
  set_color normal
end
