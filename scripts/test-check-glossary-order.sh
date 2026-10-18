#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0
#
# Self test for check-glossary-order.py. Run: ./scripts/test-check-glossary-order.sh
#
# Each case writes a small glossary fixture to a temp directory and checks the
# script's exit code on it.
set -euo pipefail

script="$(cd "$(dirname "$0")" && pwd)/check-glossary-order.py"
work=$(cd "$(mktemp -d)" && pwd -P)
trap 'rm -rf "$work"' EXIT

passed=0
failures=0

# expect <case name> <wanted exit code> <fixture path>
expect() {
  local name=$1 want=$2 got=0
  python3 "$script" "$3" >/dev/null 2>&1 || got=$?
  if [ "$got" -eq "$want" ]; then
    echo "PASS  $name"
    passed=$((passed + 1))
  else
    echo "FAIL  $name (wanted exit $want, got $got)" >&2
    failures=$((failures + 1))
  fi
}

# glossary <file> <entry lines...>: a glossary with the entries under "## Terms".
glossary() {
  local file=$1
  shift
  {
    printf '# Glossary\n\n## Terms\n\n'
    for entry in "$@"; do printf '%s\n\n' "$entry"; done
    printf '## Troubleshooting\n\n**Zebra question.** Not an entry.\n\n**A question.** Not an entry.\n'
  } >"$file"
}

glossary "$work/sorted.md" \
  "**Agent.** One." "**API (application programming interface).** Two." \
  "**Block explorer.** Three." "**Blockchain, or chain.** Four." \
  "**Fee-bump transaction.** Five." "**funding address.** Six."
expect "sorted entries pass, ignoring case, punctuation and later sections" 0 "$work/sorted.md"

glossary "$work/swapped.md" \
  "**Agent.** One." "**Blockchain, or chain.** Four." \
  "**API (application programming interface).** Two." "**Fee-bump transaction.** Five."
expect "two swapped entries fail" 1 "$work/swapped.md"

glossary "$work/duplicate.md" "**Agent.** One." "**Agent.** Again."
expect "a repeated entry fails" 1 "$work/duplicate.md"

printf '# Glossary\n\nNo terms section here.\n' >"$work/no-terms.md"
expect "a glossary with no Terms section fails closed" 2 "$work/no-terms.md"

glossary "$work/empty.md"
expect "a Terms section with no entries fails closed" 2 "$work/empty.md"

expect "a missing file fails closed" 2 "$work/does-not-exist.md"

echo
echo "$passed passed, $failures failed"
[ "$failures" -eq 0 ]
