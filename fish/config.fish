# disable greeting
set fish_greeting ""

# standard variables
set -gx EDITOR vim
set -gx PAGER less

# aliases
alias e $EDITOR
alias vi nvim
alias vim nvim
alias ls 'ls -FGh'

# path
set -gx PATH $PATH ~/.npm/bin ~/.cargo/bin

function reload -d 'reloads the fish configuration'
  source ~/.config/fish/config.fish
end
