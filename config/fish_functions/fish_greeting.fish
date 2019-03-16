function fish_greeting
  set_color brblack
  date +" %A, %B %d, %Y"
  if type -q fortune
    printf ' %s\n' (fortune -s -n 50 computers)
  end
  set_color normal
end
