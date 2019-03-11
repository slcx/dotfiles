#!/usr/bin/env python3

import os
import os.path
import sys

files = {
    'config': {
        'gitconfig': '~/.gitconfig',
        'gpg-agent.conf': '~/.gnupg/gpg-agent.conf',
        'kitty.conf': '~/Library/Preferences/kitty/kitty.conf',
        'fish_functions': '~/.config/fish/functions',
    },
    'rc': {
        'eslintrc.js': '~/.eslintrc.js',
        'hammerspoon_init.lua': '~/.hammerspoon/init.lua',
        'config.fish': '~/.config/fish/config.fish',
        'init.vim': '~/.config/nvim/init.vim',
        'zshrc': '~/.zshrc',
    },
}


def link(source, target):
    target_dir = os.path.dirname(target)
    os.makedirs(target_dir, exist_ok=True)
    if os.path.lexists(target):
        if not os.path.islink(target):
            print(f'err: {target} exists and is not a symlink')
            sys.exit(1)
        else:
            print(f'warn: {target} points somewhere already, overriding')
            os.unlink(target)
    os.symlink(os.path.abspath(source), target)


for folder, entries in files.items():
    for source_file, target_file in entries.items():
        source_file = os.path.expanduser(source_file)
        target_file = os.path.expanduser(target_file)
        print(f'{folder}/{source_file} -> {target_file}')
        link(f'{folder}/{source_file}', target_file)
