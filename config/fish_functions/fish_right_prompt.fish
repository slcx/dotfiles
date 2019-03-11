function fish_right_prompt
  set -l seconds (math -s0 "$CMD_DURATION / 1000")
  set -l hours (math "$seconds / (60 * 60)")

  command_duration

  if test "$status" -eq 0
    set_color green; echo -n "^_^"; set_color normal
  else
    set_color -o red; echo -n "O_o"; set_color normal
  end
end
