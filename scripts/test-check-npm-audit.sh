#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0
# Self test for check-npm-audit.py. Run: ./scripts/test-check-npm-audit.sh
#
# Each case feeds a small npm audit report and an accepted list to the check
# and compares the exit code.
set -euo pipefail

script="$(cd "$(dirname "$0")" && pwd)/check-npm-audit.py"
work=$(cd "$(mktemp -d)" && pwd -P)
trap 'rm -rf "$work"' EXIT

passed=0
failures=0

# report <file> <advisory ids...>: an npm audit --json report with one
# vulnerable package per advisory, plus a package that only inherits one.
report() {
  local file=$1
  shift
  python3 - "$file" "$@" <<'PY'
import json, sys
path, ids = sys.argv[1], sys.argv[2:]
vulns = {}
for i, ghsa in enumerate(ids):
    name = f"pkg{i}"
    vulns[name] = {"name": name, "severity": "high", "via": [
        {"source": i, "name": name, "title": "t", "severity": "high",
         "url": f"https://github.com/advisories/{ghsa}", "range": "*"}]}
if ids:
    vulns["parent"] = {"name": "parent", "severity": "high", "via": ["pkg0"]}
json.dump({"auditReportVersion": 2, "vulnerabilities": vulns}, open(path, "w"))
PY
}

accepted() {
  local file=$1
  shift
  python3 - "$file" "$@" <<'PY'
import json, sys
path, ids = sys.argv[1], sys.argv[2:]
json.dump({"accepted": [{"id": i, "package": "pkg", "reason": "test"} for i in ids]}, open(path, "w"))
PY
}

# expect <case name> <wanted exit code> <report> <accepted list>
expect() {
  local name=$1 want=$2 got=0
  python3 "$script" "$3" "$4" >/dev/null 2>&1 || got=$?
  if [ "$got" -eq "$want" ]; then
    echo "PASS  $name"
    passed=$((passed + 1))
  else
    echo "FAIL  $name (wanted exit $want, got $got)" >&2
    failures=$((failures + 1))
  fi
}

report "$work/clean.json"
accepted "$work/none.json"
expect "a clean report passes" 0 "$work/clean.json" "$work/none.json"

report "$work/one.json" GHSA-aaaa-bbbb-cccc
expect "an advisory that is not accepted fails" 1 "$work/one.json" "$work/none.json"

accepted "$work/ok.json" GHSA-aaaa-bbbb-cccc
expect "an accepted advisory passes" 0 "$work/one.json" "$work/ok.json"

report "$work/two.json" GHSA-aaaa-bbbb-cccc GHSA-dddd-eeee-ffff
expect "a second advisory beside an accepted one fails" 1 "$work/two.json" "$work/ok.json"

expect "an accepted advisory that no longer appears fails" 1 "$work/clean.json" "$work/ok.json"

python3 - "$work/noreason.json" <<'PY'
import json, sys
json.dump({"accepted": [{"id": "GHSA-aaaa-bbbb-cccc", "package": "pkg", "reason": ""}]}, open(sys.argv[1], "w"))
PY
expect "an accepted entry without a reason fails" 2 "$work/one.json" "$work/noreason.json"

printf 'not json' >"$work/broken.json"
expect "an unreadable report fails" 2 "$work/broken.json" "$work/none.json"

echo
echo "$passed passed, $failures failed"
[ "$failures" -eq 0 ]
