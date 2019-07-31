#!/usr/bin/env python3

import collections
import sys
from pathlib import Path

# the indentation character(s) used in .links files
INDENT = '  '


def parse_pathsfile(source: str) -> dict:
    def die():
        print('ERROR\t invalid Paths file syntax', file=sys.stderr)
        sys.exit(1)

    stack = collections.deque([{}])
    indents = 0

    for line in source.splitlines():
        if line == '':
            continue

        if ':' not in line:
            die()

        key, value = line.split(':')

        first_character_index = len(key) - len(key.lstrip())
        current_indents = key.count(INDENT, 0, first_character_index)

        key = key.strip()
        value = value.strip()

        # when dedenting, go back some levels
        if current_indents < indents:
            for _ in range(indents - current_indents):
                stack.pop()
        indents = current_indents

        head = stack[-1]

        if value == '':
            head[key] = {}
            stack.append(head[key])
        else:
            head[key] = value

    return stack[0]


def link(source: Path, target: Path) -> None:
    if source.resolve() == target.resolve():
        return

    target.parent.mkdir(exist_ok=True)

    if target.exists():
        if not target.is_symlink():
            print(f"WARNING\t {target} exists and it's not a symlink. ignoring",
                  file=sys.stderr)
            return

        points_to = target.resolve()
        print(f"WARNING\t {target} already points to {points_to}, overriding",
              file=sys.stderr)
        target.unlink()

    print(f"LINK\t {target} \N{rightwards arrow} {source}")
    target.symlink_to(source.resolve())


def resolve_target(source: dict, target: dict) -> str:
    if isinstance(target, dict):
        try:
            return target[sys.platform]
        except KeyError:
            print(f"ERROR\t Cannot resolve destination for {source} for "
                  f"platform '{sys.platform}'.", file=sys.stderr)
            sys.exit(1)


def is_valid_target(value) -> bool:
    valid_platforms = {'linux', 'win32', 'cygwin', 'darwin'}
    valid_platform_mapping = (
        isinstance(value, dict)
        and all(key in valid_platforms for key in value.keys())
    )

    return isinstance(value, str) or valid_platform_mapping


def traverse_tree(path: Path, tree: dict) -> None:
    for key, value in tree.items():
        if is_valid_target(value):
            # if the value is a valid target and not another subtree to go
            # deeper into the filesystem, link
            source = Path(path / key).expanduser()
            if isinstance(value, dict):
                target = Path(resolve_target(key, value)).expanduser()
            else:
                target = Path(value).expanduser()

            link(source, target)
        else:
            # continue deeper into the subtree, following the filesystem as we
            # go along
            if not path.is_dir():
                print(f"ERROR\t Failed to locate '{path.resolve()}'.", file=sys.stderr)
                sys.exit(1)

            traverse_tree(path / key, value)


if __name__ == '__main__':
    file = 'dotfiles.links'

    if len(sys.argv) >= 2:
        file = sys.argv[1]

    dotfiles = Path(__file__).parent
    paths_file = Path(dotfiles / file)
    paths_text = paths_file.read_text()

    tree = parse_pathsfile(paths_text)
    # __import__('pprint').pprint(parse_pathsfile(paths_text), compact=False)

    traverse_tree(dotfiles, tree)
