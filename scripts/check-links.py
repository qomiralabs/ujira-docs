#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0
#
# Checks every relative link in the repo's Markdown files: the target file
# must exist inside the repository, and a "#heading" fragment must match a
# heading in the target. Inline links and reference definitions are checked.
# Links to other sites (any URL with a scheme, such as https: or mailto:) are
# skipped. Links inside fenced code blocks and inline code are ignored.
#
# Heading anchors follow GitHub's rules: lowercase, punctuation removed except
# hyphens and underscores (so inline code keeps its text and loses only its
# backticks), spaces turned into hyphens, and a repeated heading gets -1, -2
# and so on. Percent-encoded paths and fragments, such as %20 for a space, are
# decoded before they are resolved.
#
# Files come from `git ls-files` (tracked plus new files that are not
# ignored). If git cannot list them, the check fails rather than passing.
#
# Standard library only, no dependencies.
#
# Usage: scripts/check-links.py
# Exit codes: 0 every link resolves, 1 broken links named on stderr,
# 2 the tree could not be listed.

import os
import re
import subprocess
import sys
from urllib.parse import unquote

INLINE_LINK = re.compile(r"!?\[[^\]]*\]\(\s*<?([^)\s>]+)>?(?:\s+\"[^\"]*\")?\s*\)")
REFERENCE_DEF = re.compile(r"^\s{0,3}\[[^\]]+\]:\s*<?(\S+?)>?(?:\s+.*)?$")
HEADING = re.compile(r"^\s{0,3}(#{1,6})\s+(.*?)\s*#*\s*$")
FENCE = re.compile(r"^\s{0,3}(`{3,}|~{3,})")
INLINE_CODE = re.compile(r"(`+).+?\1")
SCHEME = re.compile(r"^[a-zA-Z][a-zA-Z0-9+.-]*:")


def run_git(args):
    try:
        result = subprocess.run(["git", *args], capture_output=True, check=False)
    except OSError as error:
        return None, str(error)
    if result.returncode != 0:
        return None, result.stderr.decode(errors="replace").strip()
    return result.stdout, ""


def prose_lines(text, keep_inline_code=False):
    """Yields (line number, line) outside fenced code.

    Inline code is removed unless keep_inline_code is set, so a link written
    inside a code span is not checked."""
    fence = None
    for number, line in enumerate(text.splitlines(), start=1):
        match = FENCE.match(line)
        if fence:
            if match and match.group(1)[0] == fence[0] and len(match.group(1)) >= len(fence):
                fence = None
            continue
        if match:
            fence = match.group(1)
            continue
        yield number, line if keep_inline_code else INLINE_CODE.sub("", line)


def slug(heading):
    text = re.sub(r"\[([^\]]*)\]\([^)]*\)", r"\1", heading)
    text = text.strip().lower()
    text = re.sub(r"[^\w\- ]", "", text)
    return text.replace(" ", "-")


def anchors(text):
    seen = {}
    found = set()
    # Headings keep their inline code: GitHub drops only the backticks.
    for _, line in prose_lines(text, keep_inline_code=True):
        match = HEADING.match(line)
        if not match:
            continue
        base = slug(match.group(2))
        count = seen.get(base, 0)
        seen[base] = count + 1
        found.add(base if count == 0 else f"{base}-{count}")
    return found


def main():
    top, error = run_git(["rev-parse", "--show-toplevel"])
    if top is None or not top.strip():
        print(f"check-links: could not find the git repository: {error}", file=sys.stderr)
        return 2
    root = os.path.realpath(top.decode().strip())
    listing, error = run_git(["-C", root, "ls-files", "-z", "--cached", "--others", "--exclude-standard"])
    if listing is None:
        print(f"check-links: git could not list the files to check: {error}", file=sys.stderr)
        return 2

    files = [name for name in listing.decode().split("\0") if name.endswith(".md")]
    cache = {}

    def read(path):
        if path not in cache:
            with open(path, encoding="utf-8") as handle:
                cache[path] = handle.read()
        return cache[path]

    broken = []
    checked = 0
    for name in files:
        path = os.path.join(root, name)
        if not os.path.isfile(path):
            continue
        text = read(path)
        for number, line in prose_lines(text):
            targets = [m.group(1) for m in INLINE_LINK.finditer(line)]
            definition = REFERENCE_DEF.match(line)
            if definition:
                targets.append(definition.group(1))
            for target in targets:
                if SCHEME.match(target):
                    continue
                checked += 1
                where = f"{name}:{number}: {target}"
                file_part, _, fragment = target.partition("#")
                # Links may percent-encode characters, such as a space as %20.
                file_part, fragment = unquote(file_part), unquote(fragment)
                if file_part:
                    resolved = os.path.realpath(os.path.join(os.path.dirname(path), file_part))
                    if os.path.commonpath([root, resolved]) != root:
                        broken.append(f"{where} (outside the repository)")
                        continue
                    if not os.path.exists(resolved):
                        broken.append(f"{where} (no such file)")
                        continue
                else:
                    resolved = path
                if fragment:
                    if not resolved.endswith(".md") or not os.path.isfile(resolved):
                        broken.append(f"{where} (heading link to a file that is not Markdown)")
                    elif fragment not in anchors(read(resolved)):
                        broken.append(f"{where} (no such heading)")

    for item in broken:
        print(f"broken link: {item}", file=sys.stderr)
    if broken:
        print(f"check-links: {len(broken)} broken of {checked} relative link(s) in {len(files)} file(s)", file=sys.stderr)
        return 1
    print(f"check-links: {checked} relative link(s) in {len(files)} Markdown file(s), all resolve")
    return 0


if __name__ == "__main__":
    sys.exit(main())
