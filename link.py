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


def link_category(category: Path, links: dict) -> None:
    for source, target in links.items():
        if isinstance(target, dict):
            try:
                target = target[sys.platform]
            except KeyError:
                print(f"ERROR\t Cannot resolve destination for {source} for "
                      f"platform '{sys.platform}'.", file=sys.stderr)
                sys.exit(1)

        source = Path(category / source).expanduser()
        target = Path(target).expanduser()
        link(source, target)


if __name__ == '__main__':
    file = 'dotfiles.links'

    if len(sys.argv) >= 2:
        file = sys.argv[1]

    dotfiles = Path(__file__).parent
    paths_file = Path(dotfiles / file)
    paths_text = paths_file.read_text()

    tree = parse_pathsfile(paths_text)
    # __import__('pprint').pprint(parse_pathsfile(paths_text), compact=False)

    for category, links in tree.items():
        category = Path(dotfiles / category)

        if not category.is_dir():
            print(f"ERROR\t Category '{category}' doesn't exist.",
                  file=sys.stderr)
            sys.exit(1)

        link_category(category, links)
