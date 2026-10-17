#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0
# Self test for check-dashes.sh. Run: ./scripts/test-check-dashes.sh
set -euo pipefail

script="$(cd "$(dirname "$0")" && pwd)/check-dashes.sh"
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT

failures=0
pass() { echo "ok: $1"; }
fail() { echo "FAIL: $1" >&2; failures=$((failures + 1)); }

# Runs check-dashes.sh in a directory and prints its exit code.
run_in() {
  local dir=$1
  shift
  local code=0
  (cd "$dir" && env "$@" "$script") >/dev/null 2>&1 || code=$?
  echo "$code"
}

# A fake git that fails every command.
mkdir -p "$work/git-fails"
cat >"$work/git-fails/git" <<'EOF'
#!/usr/bin/env bash
exit 128
EOF
chmod +x "$work/git-fails/git"

# A fake git that finds the repository but fails to list its files.
mkdir -p "$work/listing-fails" "$work/fake-repo"
cat >"$work/listing-fails/git" <<EOF
#!/usr/bin/env bash
if [ "\$1" = "rev-parse" ]; then echo "$work/fake-repo"; exit 0; fi
exit 128
EOF
chmod +x "$work/listing-fails/git"

# A real repository with one clean file.
mkdir -p "$work/clean"
git -C "$work/clean" init -q
printf 'plain text, no dashes\n' >"$work/clean/page.md"

# A real repository with one file containing an em dash, written as bytes.
mkdir -p "$work/dirty"
git -C "$work/dirty" init -q
printf 'bad \xe2\x80\x94 here\n' >"$work/dirty/page.md"

code=$(run_in "$work/clean" PATH="$work/git-fails:$PATH")
if [ "$code" -ne 0 ]; then pass "fails when git cannot find the repository"; else fail "exit 0 when git cannot find the repository"; fi

code=$(run_in "$work/fake-repo" PATH="$work/listing-fails:$PATH")
if [ "$code" -ne 0 ]; then pass "fails when git cannot list files"; else fail "exit 0 when git cannot list files"; fi

code=$(run_in "$work/clean" PATH="$PATH")
if [ "$code" -eq 0 ]; then pass "passes on a clean repository"; else fail "exit $code on a clean repository"; fi

code=$(run_in "$work/dirty" PATH="$PATH")
if [ "$code" -eq 1 ]; then pass "fails with exit 1 when a file has a dash"; else fail "exit $code when a file has a dash"; fi

if [ "$failures" -ne 0 ]; then
  echo "$failures test(s) failed." >&2
  exit 1
fi
echo "All check-dashes tests passed."
