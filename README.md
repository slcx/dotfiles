# `dotfiles`

Hello, and welcome to my dotfiles! Feel free to poke around.

Here's some things I use on a daily basis:

- [Arch Linux][arch]
- [bspwm][bspwm]
  - [lemonbar][lemonbar] with no special patches
  - [dmenux][dmenux], which is just [dmenu][dmenu] with a load of patches
    - Necessary for proper height, and fuzzy searching
  - Previously...
    - [Awesome window manager][awesomewm]
      - Configured with [MoonScript][moonscript] instead of Lua
      - Compiled using [tup][tup], needs MoonScript installed
    - [i3][i3]
- [@neeasade](https://github.com/neeasade)'s [`st`][st] [fork][xst]
  - [zsh][zsh] is my `$SHELL`
  - Configured using `~/.Xresources`, check `xorg` folder
- Autostarting apps (beware, proprietary software!)
  - [Chromium][chromium] (not Google Chrome): www
  - [Slack][slack]: chatting
  - [Discord][discord]: chatting
  - Thunderbird: email
- [tmux][tmux] (launched automatically in `~/.zshrc` for scrolling)
- [Neovim][nvim] instead of [Vim][vim] (both are great)
- [Vertex-Light][vertex] GTK2/3 themes

[arch]:       https://www.archlinux.org/
[nvim]:       https://neovim.io/
[vim]:        http://www.vim.org/
[xst]:        https://github.com/neeasade/xst
[st]:         http://st.suckless.org/
[moonscript]: https://moonscript.org/
[awesomewm]:  https://awesome.naquadah.org/
[tup]:        http://gittup.org/tup/
[chromium]:   https://www.chromium.org/
[slack]:      https://slack.com/
[discord]:    https://discordapp.com
[tmux]:       https://tmux.github.io/
[vertex]:     https://github.com/horst3180/vertex-theme
[zsh]:        https://www.zsh.org/
[i3]:         https://i3wm.org/
[lemonbar]:   https://github.com/LemonBoy/bar
[dmenux]:     https://github.com/lvitals/dmenux
[dmenu]:      http://tools.suckless.org/dmenu/

# using
Before using (for some reason), make sure that 
```
$ stow [folder]
```
