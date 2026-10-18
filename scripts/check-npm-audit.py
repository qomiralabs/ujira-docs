#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0
#
# Fails on any advisory in an `npm audit --json` report that is not in the
# accepted list. An accepted entry needs a reason, and an accepted advisory
# that no longer appears fails too, so the list cannot keep a stale
# exception after the fix lands.
#
# Advisories are read from the objects in each package's "via" list; a
# package that only inherits an advisory from a dependency adds nothing. Each
# is keyed on its GHSA id, or on npm's source id (npm-<n>) when it has no
# GHSA URL.
#
# Standard library only, no dependencies.
#
# Usage: scripts/check-npm-audit.py <audit report json> <accepted list json>
# Exit codes: 0 only accepted advisories, 1 an advisory is not accepted or an
# accepted one is gone, 2 a file could not be read.
import json
import re
import sys


def advisory_id(via: dict) -> str:
    """The GHSA id from the advisory URL, or npm's source id when there is no
    GHSA URL, so no two advisories share an empty id."""
    match = re.search(r"GHSA(?:-[23456789cfghjmpqrvwx]{4}){3}", str(via.get("url") or ""))
    if match:
        return match.group(0)
    source = via.get("source")
    if isinstance(source, int) and not isinstance(source, bool):
        return f"npm-{source}"
    raise ValueError(f"advisory {via.get('title')!r} has neither a GHSA URL nor a source id")


def main() -> int:
    if len(sys.argv) != 3:
        print("usage: check-npm-audit.py <audit report> <accepted list>", file=sys.stderr)
        return 2
    try:
        with open(sys.argv[1], encoding="utf-8") as handle:
            report = json.load(handle)
        with open(sys.argv[2], encoding="utf-8") as handle:
            accepted_doc = json.load(handle)
        vulnerabilities = report["vulnerabilities"]
        accepted = {}
        for entry in accepted_doc["accepted"]:
            ident, reason = entry["id"], entry["reason"]
            if not isinstance(ident, str) or not ident or not isinstance(reason, str) or not reason.strip():
                raise ValueError(f"accepted entry {entry!r} needs an id and a reason")
            accepted[ident] = entry
    except (OSError, ValueError, KeyError, TypeError) as error:
        print(f"check-npm-audit: cannot read the inputs: {error}", file=sys.stderr)
        return 2

    found = {}
    try:
        for package in vulnerabilities.values():
            for via in package.get("via", []):
                if isinstance(via, dict):
                    found[advisory_id(via)] = via
    except ValueError as error:
        print(f"check-npm-audit: {error}", file=sys.stderr)
        return 2

    failed = False
    for ident in sorted(found):
        via = found[ident]
        if ident in accepted:
            print(f"check-npm-audit: accepted {ident} in {via.get('name')}: {accepted[ident]['reason']}")
        else:
            print(
                f"check-npm-audit: {ident} ({via.get('severity')}) in {via.get('name')} {via.get('range')}: {via.get('title')}",
                file=sys.stderr,
            )
            failed = True
    for ident in sorted(set(accepted) - set(found)):
        print(f"check-npm-audit: {ident} is accepted but no longer reported, remove it", file=sys.stderr)
        failed = True
    if failed:
        return 1
    print(f"check-npm-audit: {len(found)} advisory(ies), all accepted")
    return 0


if __name__ == "__main__":
    sys.exit(main())
