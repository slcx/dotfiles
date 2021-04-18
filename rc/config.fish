# slice's config.fish

# for some inane reason, fish creates fish_user_paths as a global variable, preventing
# us from using it as a universal variable.
set -eg fish_user_paths

if not functions -q fisher
  set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
  curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
  fish -c fisher
end

if status is-interactive
  set -l platform (uname)

  if test -n "$maintain_ssh_agent"
    set -l retainer_file ~/.ssh-agent
    if pgrep ssh-agent >/dev/null
      # agent already running, attempt to source file
      if test -f $retainer_file
        head -n 2 $retainer_file | source
      else
        echo "error: ssh-agent running, but $retainer_file doesn't exist! D:"
      end
    else
      # agent not running; spawn it
      echo "agent not running yet, spawning! o/"
      ssh-agent -c > ~/.ssh-agent
      source ~/.ssh-agent
    end
  end

  # editor
  alias e "$EDITOR"
  alias se "sudo $EDITOR"

  switch $platform
    case Darwin
      alias ls 'ls -GFh'

      # homebrew
      abbr -a -g br 'brew'
      abbr -a -g bri 'brew install'
      abbr -a -g bru 'brew uninstall'
      abbr -a -g brup 'brew up && brew upgrade'
      abbr -a -g brcl 'brew cleanup'
    case Linux
      alias ls 'ls -Fh --color=auto'

      # systemd
      abbr -a -g sc 'sudo systemctl'
      abbr -a -g scs 'sudo systemctl status'
      abbr -a -g sce 'sudo systemctl enable'
      abbr -a -g scen 'sudo systemctl enable --now'
      abbr -a -g scd 'sudo systemctl disable'
      abbr -a -g scdn 'sudo systemctl disable --now' # oh no
      abbr -a -g scu 'systemctl --user'
      # systemd-journal
      abbr -a -g jc 'sudo journalctl'
      abbr -a -g jcu 'sudo journalctl -u'

      # apt
      abbr -a -g ai 'sudo apt install'
      abbr -a -g au 'sudo apt update'
      abbr -a -g ag 'sudo apt upgrade'
      abbr -a -g arm 'sudo apt remove'
      abbr -a -g ase 'sudo apt search'
      abbr -a -g ash 'sudo apt show'
      abbr -a -g apu 'sudo apt purge'

      # pacman
      abbr -a -g pc 'sudo pacman'
      abbr -a -g pcu 'sudo pacman -Syu'
  end

  # ls
  alias ll 'ls -l'
  alias la 'ls -al'

  # docker
  abbr -a -g dk 'docker'
  abbr -a -g dkc 'docker-compose'

  # langs
  abbr -a -g ipy 'ipython'
  abbr -a -g py 'python3'
  alias irb 'irb --simple-prompt'
  abbr -a -g bl 'bloop'

  # shorthands
  abbr -a -g md 'mkdir'
  abbr -a -g ydl 'youtube-dl'

  # shorthands for long commands
  alias ydle 'youtube-dl -f bestaudio --audio-format mp3 --extract-audio'
  # alias usage 'du -h -d 1 .'
  alias usage 'sn sort -d 1'
  abbr -a -g lfs 'python3 -m lifesaver.cli'

  if type -q hub
    alias git 'hub'
  end

  # git(1)
  abbr -a -g g 'git'
  abbr -a -g gi 'git init'
  abbr -a -g gap 'git add -p'
  abbr -a -g ga 'git add'
  abbr -a -g grb 'git rebase'
  abbr -a -g gca 'git commit --amend'
  abbr -a -g gc 'git commit'
  abbr -a -g gco 'git checkout'
  abbr -a -g gr 'git remote'
  abbr -a -g gd 'git diff'
  abbr -a -g gds 'git diff --staged'
  abbr -a -g gt 'git tag'
  abbr -a -g gst 'git status'
  abbr -a -g gp 'git push'
  abbr -a -g gpf 'git push --force'
  abbr -a -g gpl 'git pull'
  abbr -a -g grh 'git reset HEAD'
  abbr -a -g gs 'git show'
  abbr -a -g gsh 'git stash'
  abbr -a -g gl 'git log --graph'
  abbr -a -g grm 'git rm'
  abbr -a -g gb 'git branch'
  abbr -a -g gcl 'git clone'
  abbr -a -g grs 'git restore'

  # colors
  set fish_color_normal normal
  set fish_color_command green
  set fish_color_quote brblue
  set fish_color_redirection yellow
  set fish_color_end yellow
  set fish_color_error red --bold
  set fish_color_param blue
  set fish_color_comment brblack
  set fish_color_match --background=brblue
  set fish_color_selection white --background=brblack
  set fish_color_search_match bryellow --background=brblack
  set fish_color_operator magenta
  set fish_color_escape blue --bold
  # fish_color_cwd
  set fish_color_autosuggestion brblack
  # fish_color_user
  # fish_color_host
  set fish_color_cancel --reverse
  set fish_pager_color_prefix normal --bold
  set fish_pager_color_completion normal
  set fish_pager_color_description blue
  set fish_pager_color_progress normal --background=brblack
  # fish_pager_color_secondary
end

# fnm
# fnm env --multi | source

# pyenv
# pyenv init - | source
