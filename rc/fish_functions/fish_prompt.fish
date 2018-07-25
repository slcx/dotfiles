function fish_prompt
  test $status != 0
  and set -l face (set_color -o red)'~_~'(set_color normal)
  or set -l face (set_color -o green)'^_^'(set_color normal)

  echo

  set -l hostname (hostname | cut -d . -f 1)

  printf '%s%s%s@%s%s %s%s%s\n' \
    (set_color normal) (whoami) \
    (set_color brblack) $hostname (set_color normal) \
    (set_color red) (prompt_pwd) (set_color normal)

  set time_string ""
  if [ $CMD_DURATION != 0 ]
    set -l hours (math "$CMD_DURATION / 3600000")
    set -l minutes (math "$CMD_DURATION % 3600000 / 60000")
    set -l seconds (math "$CMD_DURATION % 60000 / 1000")
    set -l pretty ''

    [ $hours -gt 0 ]; and set pretty {$pretty}{$hours}'h'
    [ $minutes -gt 0 ]; and set pretty {$pretty}{$minutes}'m'
    [ $seconds -gt 0 ]; and set pretty {$pretty}{$seconds}'s'

    [ $seconds -gt 3 -o $minutes -gt 0 -o $hours -gt 0 ]
    and set time_string (set_color -o f74782)"($pretty) "(set_color normal)
    or set time_string ""
  end

  printf '%s%s %s $ %s ' \
    $time_string $face (set_color -r b2ceee) (set_color normal)
end
