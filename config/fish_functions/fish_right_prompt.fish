function fish_right_prompt
  command_duration

  if test "$status" -eq 0
    set_color green; echo -n "^_^"; set_color normal
  else
    set_color -o red; echo -n "O_o"; set_color normal
  end
end
