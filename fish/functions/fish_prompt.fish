function fish_prompt
  # time
  echo -n (date +"[%l:%m]")' '

  # pwd
  set_color -o $fish_color_pwd
  echo -n (prompt_pwd)'> '

  set_color normal
end
