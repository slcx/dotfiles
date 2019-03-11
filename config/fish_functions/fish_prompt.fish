function fish_prompt
  # output ssh connection information
  if set -q SSH_CONNECTION
    printf '%s%s%s@%s%s ' \
      (set_color magenta) \
      "$USER" \
      (set_color -o magenta) \
      (hostname -s) \
      (set_color normal)
  end

  printf '%s%s$%s ' (prompt_pwd) (set_color -o) (set_color normal)
end
