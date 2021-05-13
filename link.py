#!/usr/bin/env python3

import collections
import sys
from pathlib import Path

IGNORED_NAMES = frozenset(["readme.md", "link.py", "go.sh", "defaults.sh", ".git"])


def link(*, symlink: Path, points_to: Path) -> None:
    if symlink.resolve() == points_to.resolve():
        # if the symlink path already resolves to the file, then we have nothing to do
        return

    if (
        symlink.parent.exists() or symlink.parent.is_symlink()
    ) and not symlink.parent.is_dir():
        # if the symlink exists as a node on disk and isn't a directory, then die
        print(f"error: {symlink.parent} already exists and isn't a directory")
        sys.exit(1)

    symlink.parent.mkdir(parents=True, exist_ok=True)

    if symlink.is_symlink():
        existing_target = symlink.resolve()
        if symlink.exists():
            print(
                f"warn: {symlink} is already a link to {existing_target}, overwriting",
                file=sys.stderr,
            )
        else:
            print(
                f"warn: {symlink} is a broken link to {existing_target}, overwriting",
                file=sys.stderr,
            )
        symlink.unlink()
    elif symlink.exists():
        print(
            f"warn: {symlink} exists and it's not a symlink, ignoring", file=sys.stderr
        )
        return

    print(f"ln -s {points_to} {symlink}")
    symlink.symlink_to(points_to.resolve())


def is_valid_target(value) -> bool:
    valid_platforms = {"linux", "win32", "cygwin", "darwin"}
    valid_platform_mapping = isinstance(value, dict) and all(
        key in valid_platforms for key in value.keys()
    )

    return isinstance(value, str) or valid_platform_mapping


def link_everything(root: Path, *, relative_to: Path) -> None:
    for child in root.iterdir():
        if child.name in IGNORED_NAMES:
            continue

        relative_path = relative_to / child.name

        if child.is_dir():
            link_everything(child, relative_to=relative_path)
            continue

        link(symlink=relative_path, points_to=child)


if __name__ == "__main__":
    link_everything(Path.cwd(), relative_to=Path.home())
