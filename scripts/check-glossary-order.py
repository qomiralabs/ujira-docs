#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0
#
# Checks that the glossary's entries are in alphabetical order. An entry is a
# line that starts with a bold term, such as "**Anchor.** ...", inside the
# "## Terms" section. Lines in other sections are not entries.
#
# Terms are compared ignoring case and punctuation, so "Fee-bump transaction"
# sorts as "feebump transaction" and "API (application ...)" as "api
# application ...". Spaces count and sort before letters, so "Block explorer"
# comes before "Blockchain". A repeated term fails.
#
# Fails closed: a missing file, a missing Terms section or a Terms section with
# no entries is an error, not a pass.
#
# Standard library only, no dependencies.
#
# Usage: scripts/check-glossary-order.py [path to glossary]
# The default path is docs/glossary.md in this repository.
# Exit codes: 0 sorted, 1 out of order or repeated (named on stderr),
# 2 the glossary could not be read or has no entries.

import os
import re
import sys

DEFAULT = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "docs", "glossary.md")
ENTRY = re.compile(r"^\*\*(.+?)\*\*")
SECTION = re.compile(r"^##\s+(.*?)\s*$")


def sort_key(term):
    return re.sub(r"[^\w ]", "", term.casefold()).strip()


def main():
    path = sys.argv[1] if len(sys.argv) > 1 else DEFAULT
    try:
        with open(path, encoding="utf-8") as handle:
            lines = handle.read().splitlines()
    except OSError as error:
        print(f"check-glossary-order: could not read {path}: {error}", file=sys.stderr)
        return 2

    entries = []
    in_terms = False
    found_terms = False
    for number, line in enumerate(lines, start=1):
        section = SECTION.match(line)
        if section:
            in_terms = section.group(1).casefold() == "terms"
            found_terms = found_terms or in_terms
            continue
        match = ENTRY.match(line)
        if in_terms and match:
            entries.append((number, match.group(1).rstrip(".")))

    if not found_terms:
        print(f"check-glossary-order: {path} has no '## Terms' section", file=sys.stderr)
        return 2
    if not entries:
        print(f"check-glossary-order: {path} has no entries under '## Terms'", file=sys.stderr)
        return 2

    problems = []
    for (prev_line, prev), (line, term) in zip(entries, entries[1:]):
        if sort_key(term) == sort_key(prev):
            problems.append(f"line {line}: '{term}' repeats '{prev}' from line {prev_line}")
        elif sort_key(term) < sort_key(prev):
            problems.append(f"line {line}: '{term}' should come before '{prev}' on line {prev_line}")

    for problem in problems:
        print(f"check-glossary-order: {problem}", file=sys.stderr)
    if problems:
        return 1
    print(f"check-glossary-order: {len(entries)} entries in alphabetical order")
    return 0


if __name__ == "__main__":
    sys.exit(main())
