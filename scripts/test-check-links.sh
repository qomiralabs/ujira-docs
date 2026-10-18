#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0
#
# Self test for check-links.py. Run: ./scripts/test-check-links.sh
#
# Each case builds a throwaway git repo in a temp directory, writes some
# Markdown files and checks the exit code.
set -euo pipefail

script="$(cd "$(dirname "$0")" && pwd)/check-links.py"
work=$(cd "$(mktemp -d)" && pwd -P)
trap 'rm -rf "$work"' EXIT

passed=0
failures=0

new_repo() {
  repo="$work/$1"
  mkdir -p "$repo/docs"
  git -C "$repo" init -q
  printf '# Target\n\n## What it is\n\n## Example\n\n## Example\n' >"$repo/docs/target.md"
}

# expect <case name> <wanted exit code> <repo dir> [env assignments...]
expect() {
  local name=$1 want=$2 dir=$3 got=0
  shift 3
  (cd "$dir" && env "$@" python3 "$script") >/dev/null 2>&1 || got=$?
  if [ "$got" -eq "$want" ]; then
    echo "PASS  $name"
    passed=$((passed + 1))
  else
    echo "FAIL  $name (wanted exit $want, got $got)" >&2
    failures=$((failures + 1))
  fi
}

new_repo good
printf '[a](docs/target.md) [b](docs/target.md#what-it-is) [c](#top)\n\n## Top\n' >"$repo/README.md"
printf '[d](target.md#example-1) [e](https://example.com/missing.md) [f](mailto:a@example.com)\n' >"$repo/docs/page.md"
expect "valid links, anchors and duplicate heading anchors pass" 0 "$repo"

new_repo missing-file
printf '[a](docs/nope.md)\n' >"$repo/README.md"
expect "a link to a missing file fails" 1 "$repo"

new_repo missing-anchor
printf '[a](docs/target.md#not-a-heading)\n' >"$repo/README.md"
expect "a link to a missing heading fails" 1 "$repo"

# target.md has "Example" twice, so example and example-1 exist but not
# example-2.
new_repo duplicate-anchor
printf '[a](docs/target.md#example-2)\n' >"$repo/README.md"
expect "a link past the last duplicate heading fails" 1 "$repo"

new_repo missing-local-anchor
printf '# Page\n\n[a](#nowhere)\n' >"$repo/README.md"
expect "a link to a missing heading on the same page fails" 1 "$repo"

new_repo reference
printf '[a][ref]\n\n[ref]: docs/nope.md\n' >"$repo/README.md"
expect "a reference definition to a missing file fails" 1 "$repo"

new_repo outside
printf '[a](../outside.md)\n' >"$repo/README.md"
touch "$work/outside.md"
expect "a link that leaves the repository fails" 1 "$repo"

new_repo code
# The backticks are Markdown code spans, not shell expansions.
# shellcheck disable=SC2016
printf '```md\n[a](docs/nope.md)\n```\n\nSee `[b](docs/nope.md)` inline.\n' >"$repo/README.md"
expect "links inside code are ignored" 0 "$repo"

new_repo ignored
printf '[a](docs/target.md)\n' >"$repo/README.md"
printf 'notes.md\n' >"$repo/.gitignore"
printf '[a](docs/nope.md)\n' >"$repo/notes.md"
expect "ignored files are not checked" 0 "$repo"

# A fake git that fails every command, so the file list cannot be read.
mkdir -p "$work/fake-git"
printf '#!/usr/bin/env bash\nexit 128\n' >"$work/fake-git/git"
chmod +x "$work/fake-git/git"
new_repo git-fails
printf '[a](docs/target.md)\n' >"$repo/README.md"
expect "fails closed when git cannot list files" 2 "$repo" PATH="$work/fake-git:$PATH"

echo
echo "$passed passed, $failures failed"
[ "$failures" -eq 0 ]
