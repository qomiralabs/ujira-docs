#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0
# Fails if any tracked or new (not ignored) file contains an em dash or an en dash.
set -euo pipefail

cd "$(git rev-parse --show-toplevel)"

# The two characters, written as raw UTF-8 bytes so this works with BSD and GNU grep.
em=$(printf '\xe2\x80\x94')
en=$(printf '\xe2\x80\x93')

found=0
while IFS= read -r -d '' file; do
  [ -f "$file" ] || continue
  if LC_ALL=C grep -n -F -e "$em" -e "$en" -- "$file"; then
    echo "dash found in $file" >&2
    found=1
  fi
done < <(git ls-files -z --cached --others --exclude-standard)

if [ "$found" -ne 0 ]; then
  echo "Replace em and en dashes with a comma, a colon, parentheses or the word \"to\"." >&2
  exit 1
fi
echo "No em or en dashes found."
