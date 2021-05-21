function fish_prompt
  # if we're in ssh, show username and hostname
  if set -q SSH_CONNECTION
    printf '%s%s%s@%s%s ' \
      (set_color yellow) \
      "$USER" \
      (set_color -o yellow) \
      (hostname -s) \
      (set_color normal)
  end

  set -l prompt_character ' % '
  set -l prompt_color '-r'

  if test "$USER" = "root"
    set prompt_character '#'
    set prompt_color 'red' '-o'
  end

  if test (pwd) = $HOME
    set prompt_pwd '~'
  else if test (pwd) = '/'
    set prompt_pwd '/'
  else
    set prompt_pwd (string split -r -m1 -f2 '/' (pwd))
  end

  printf '%s %s%s%s ' \
    $prompt_pwd \
    (set_color $prompt_color) \
    $prompt_character \
    (set_color normal)
end
