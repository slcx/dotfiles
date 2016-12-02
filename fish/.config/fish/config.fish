function fish_prompt
  echo "── "
end

set -gx PATH $HOME/.local/bin $PATH
set -x EDITOR nvim
set -x VISUAL less
set -x PREFIX "$HOME/.local"
