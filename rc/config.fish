if not functions -q fisher
    set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
    curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
    fish -c fisher
end

if status is-interactive
  # editor
  alias e "$EDITOR"
  alias se "sudo -E $EDITOR"

  # ls
  alias ls 'ls -GFh'
  alias ll 'ls -l'
  alias la 'ls -al'

  # systemd
  abbr -a -g sc 'sudo systemctl'
  abbr -a -g sj 'sudo journalctl'

  # docker
  abbr -a -g dk 'docker'
  abbr -a -g dkc 'docker-compose'

  # langs
  abbr -a -g ipy 'ipython'
  abbr -a -g py 'python3'
  alias irb 'irb --simple-prompt'

  # shorthands
  abbr -a -g md 'mkdir'
  abbr -a -g ydl 'youtube-dl'
  abbr -a -g br 'brew'

  # shorthands for long commands
  alias ydle 'youtube-dl --extract-audio --audio-format mp3'
  alias usage 'du -h -d 1 .'

  if type -q hub
    alias git 'hub'
  end

  abbr -a -g g 'git'
  abbr -a -g gi 'git init'
  abbr -a -g gap 'git add -p'
  abbr -a -g ga 'git add'
  abbr -a -g grb 'git rebase'
  abbr -a -g gca 'git commit --amend'
  abbr -a -g gc 'git commit -v'
  abbr -a -g gco 'git checkout'
  abbr -a -g gr 'git remote'
  abbr -a -g gd 'git diff'
  abbr -a -g gds 'git diff --staged'
  abbr -a -g gt 'git tag'
  abbr -a -g gst 'git status'
  abbr -a -g gp 'git push'
  abbr -a -g gpl 'git pull'
  abbr -a -g grh 'git reset HEAD'
  abbr -a -g gs 'git show'
  abbr -a -g gsh 'git stash'
  abbr -a -g gl 'git log --graph'
  abbr -a -g grm 'git rm'
  abbr -a -g gb 'git branch'
  abbr -a -g gcl 'git clone'
end

# fnm
# fnm env --multi | source
