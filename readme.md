# dotfiles

here are slice's dotfiles...

## usage

```sh
# create symbolic links to configuration files, according to dotfiles.links
#
# (script requires python 3.6+)
# (doesn't overwrite existing files, but links are overwritten)
$ ./link.py

# ready up fresh macOS machine
#
# (installs homebrew, packages, does interactive setup, etc.)
# (runs defaults.sh for you)
$ ./go.sh

# apply macOS defaults
$ ./defaults.sh
```
