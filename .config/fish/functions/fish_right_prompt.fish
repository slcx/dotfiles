function fish_right_prompt
  # set this so we can compare the value pre-command_duration (which modifies
  # it)
  set -l _status "$status"

  command_duration

  if test "$_status" -eq 0
    printf '%s^_^%s' (set_color green) (set_color normal)
  else
    # set -l face (random choice 'O_O' 'O_o' '>_>' 'v_v' ';_;')
    # printf '%s%s%s' (set_color -o red) "$face" (set_color normal)
    printf '%s;_;%s' (set_color -o red) (set_color normal)
  end
end
