# derived from: https://github.com/jichu4n/fish-command-timer/blob/master/conf.d/fish_command_timer.fish

function command_duration
  set -l second 1000
  set -l minute 60000
  set -l hour 3600000
  set -l day 86400000

  set -l num_days (math -s0 "$CMD_DURATION / $day")
  set -l num_hours (math -s0 "$CMD_DURATION % $day / $hour")
  set -l num_mins (math -s0 "$CMD_DURATION % $hour / $minute")
  set -l num_secs (math -s0 "$CMD_DURATION % $minute / $second")
  set -l time_str ""

  if [ $num_days -gt 0 ]
    set time_str {$time_str}{$num_days}"d "
  end
  if [ $num_hours -gt 0 ]
    set time_str {$time_str}{$num_hours}"h "
  end
  if [ $num_mins -gt 0 ]
    set time_str {$time_str}{$num_mins}"m "
  end

  set time_str {$time_str}{$num_secs}s

  if test "$time_str" != "0s"
    set_color brblack; printf "%s" $time_str; set_color normal
  end
end
