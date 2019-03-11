function fish_prompt
  printf '%s' (prompt_pwd)
  set_color -o; printf '$ '; set_color normal
end
