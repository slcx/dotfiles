function fish_right_prompt
  set -l command_status "$status"

  command_duration

  if test "$command_status" -eq 0
    set_color green; echo -n "^_^"; set_color normal
  else
    set_color -o red; echo -n "O_o"; set_color normal
  end
end
