# UJIRA docs

UJIRA is a payout rail for platforms and their agents. It pays people for their work, in their own local currency, under spending rules a human sets in advance. Every payout leaves a receipt.

These docs explain how UJIRA works, in plain English, for developers who are new to payments.

> **Status:** UJIRA is in development. The concept pages describe how UJIRA is designed to work. The API and the MCP server are not available yet, so their pages are marked **Planned** and show no request or response formats until those are final.

## Docs map

### Start here

- [What UJIRA is](docs/concepts/what-is-ujira.md): the problem it solves, the two sides (principals and recipients), and how a payout flows from start to finish
- [Glossary](docs/glossary.md): every term used in these docs, in one place

### Concepts

- [Mandates](docs/concepts/mandates.md): the spending rules that limit what an agent can pay, and the approvals above a threshold
- [Funding](docs/concepts/funding.md): how you put money into a mandate with a stablecoin deposit, and why you never need XLM
- [Payouts and split payouts](docs/concepts/payouts.md): how a payout becomes money in a person's account, and how a recipient can take one payout two ways
- [Receipts](docs/concepts/receipts.md): the permanent, verifiable proof of every payout
- [Recipient onboarding and the embed widget](docs/concepts/recipient-onboarding.md): how a person becomes payable, inside your own product
- [Stellar and payout methods](docs/concepts/chains-and-routing.md): how UJIRA settles on Stellar and reaches people in their own Stellar wallet, or in local currency through licensed anchors
- [Security and the non-custodial model](docs/concepts/security.md): who holds the money at each step, and what protects it

### Reference

- [API reference](docs/api-reference.md) (Planned)
- [MCP guide](docs/mcp-guide.md) (Planned): using UJIRA from an MCP client such as a desktop AI assistant or IDE agent
- [Changelog](CHANGELOG.md)

## Checking the docs locally

You need Node.js 20 or later and Python 3.

```sh
# Lint every Markdown file with the pinned markdownlint-cli2
npm ci --prefix tools/markdownlint --ignore-scripts --no-audit --no-fund
tools/markdownlint/node_modules/.bin/markdownlint-cli2

# Fail if any file contains an em dash or an en dash
./scripts/check-dashes.sh

# Self test for the dash check
./scripts/test-check-dashes.sh

# Fail if any file contains a literal invisible or bidirectional control character
./scripts/check-invisible-characters.py

# Self test for the invisible character check
./scripts/test-check-invisible-characters.sh

# Fail if any relative link or heading link does not resolve
./scripts/check-links.py

# Self test for the link check
./scripts/test-check-links.sh

# Fail if the glossary is not in alphabetical order
./scripts/check-glossary-order.py

# Self test for the glossary order check
./scripts/test-check-glossary-order.sh
```

All of these exit with code 0 when the docs are clean. The invisible character, link and glossary order checks need Python 3 and use its standard library only. CI runs markdownlint, the dash check, the invisible character check and the link check, with their self tests, in the `markdownlint`, `dashes`, `invisible-characters` and `links` jobs; the glossary order check is not in CI yet. markdownlint-cli2 0.23.3 (MIT) is locked with its whole dependency tree in `tools/markdownlint/package-lock.json`, resolved from releases at least 14 days old, with npm `overrides` raising katex to 0.18.2 and smol-toml to 1.9.0 past their advisories; bump the version there and in the workflow together. The `markdownlint` job also runs `npm audit` on that tree, and `scripts/check-npm-audit.py` fails on any advisory not listed, with its reason, in `tools/markdownlint/audit-accepted.json`, or on a listed one that is no longer reported. The only entry today is braces GHSA-vfj7-8cjw-p6xm, which has no patch yet (#18).

## Invisible characters

Literal bidirectional controls and invisible characters can make text read differently from what it is, and they do not show in review. To check the tree:

```sh
scripts/check-invisible-characters.py
```

It reads every tracked file as bytes. Only files whose extension is on the short binary list in the script (`png`, `jpg`, `jpeg`, `gif`, `webp`, `ico`, `woff`, `woff2`, `wasm`, `pdf`) are skipped, and only when their content starts with that format's signature; a listed name with other content fails. Every other file must be valid UTF-8 and is checked in full, and a NUL byte is reported as U+0000, so a NUL cannot make a source file skip the check. It fails on every character in the Unicode categories Cf, Zl and Zp, such as the byte order mark, zero width characters, the bidirectional controls U+202A to U+202E and U+2066 to U+2069, and U+2028 and U+2029, naming the file, line, column and code point. Categories come from Python's `unicodedata` tables, and the script uses the standard library only. It also fails on the no break space (U+00A0), narrow no break space (U+202F) and minus sign (U+2212), except in files listed in `scripts/invisible-characters-allowlist.txt`. Write any of these as an HTML entity such as `&nbsp;` or `&#x2212;`, or as an escape inside code. `scripts/test-check-invisible-characters.sh` tests the check itself.

## Pull requests

Every pull request starts from `.github/pull_request_template.md`: the linked issue, what and why, the tests run with their output, docs, a checklist, the reviews the change type needs, and the merge rules (squash only, and any commit after an approval needs review again). `scripts/check-pr-template.sh` fails if the template loses any of these or stops being plain ASCII, and `scripts/check-pr-template.test.sh` proves it; CI runs both. `.github/CODEOWNERS` names the owner of each top level path. It is advisory: on the current GitHub plan branch protection cannot require code owner review (qomiralabs/ujira#229).

## Continuous integration

`.github/workflows/ci.yml` runs on every pull request and on pushes to `development`, `staging` and `main`, with read-only permissions. Its `checks` job runs the pull request template check and its self test. Its `secrets` job lints the workflows with actionlint and runs the secret scan below. The `markdownlint`, `dashes`, `invisible-characters` and `links` jobs run the checks described under Checking the docs locally, with their self tests. Every action is pinned to a full commit SHA, and actionlint and gitleaks are release binaries checked against a SHA-256 in the workflow; bump a version and its hash together.

## Secret scanning

The `secrets` job in `.github/workflows/ci.yml` runs `scripts/secret-scan.sh` with gitleaks 8.30.1 (MIT licensed), downloaded from its GitHub release and checked against a pinned SHA-256. It checks out the full history and scans every commit reachable from the checked out commit, not only the change, so a key that was committed and later deleted still fails. Merge commits are scanned against each parent, so a key added while resolving a merge is found, and every file is read as text, so a `.gitattributes` entry such as `-diff` or `binary` cannot hide one. The scan refuses a shallow clone and fails unless gitleaks reports scanning exactly the commits it should: every commit with a change in a file it does not delete (commits that only delete, rename or change a mode have nothing to scan). Findings are redacted in the log.

Two limits apply to any line based scanner. Binary files are handed to gitleaks as text, so a key stored as plain text inside one is found, but a compressed or encoded one is not; a commit that only adds binary files still passes. A token split across lines, or assembled from pieces in code, is not caught either. To cover the first, the scan also refuses, by name and in any case, any commit in the history that adds or changes a key or env file, binary or not: `.pem`, `.key`, `.p12`, `.pfx`, `.jks`, `.keystore`, `.ppk`, `.p8` and `.der` files, private ssh keys such as `id_rsa` or `id_ed25519` (their `.pub` halves are allowed), and `.env`, `.env.*`, `.envrc` and `*.env` files other than `.env.example`. Names are read unquoted, so non-ASCII names are checked too. Key material and environment values belong in the secret manager.

`.gitleaks.toml` holds the default rules of gitleaks 8.30.1 with upstream's global allowlist removed, so lockfiles, `node_modules`, images, `.pem`, `.key` and `.log` files, `go.sum` and files named `gitleaks.toml` are scanned like any other file. Upstream rule allowlists that list sample keys or passwords (for the GCP API key and NuGet password rules, and one hex stopword) are removed too. The rule allowlists that remain only drop placeholders, words and template syntax, and the self test scans the file with every allowlist stripped so no key shaped literal can return. Its header names the upstream file, its hash and every edit. Inline `gitleaks:allow` comments are ignored and any `.gitleaksignore` fails the scan, so `.gitleaks.toml` is the only allowlist. Each allowlist entry must cover a single synthetic test fixture and say why it is safe; path wide and rule wide exclusions are not allowed.

On pull requests the scan reads `.gitleaks.toml` from the base branch rather than from the change, so an edit to that file in a pull request does not change the rules that pull request is scanned with; the edit takes effect once it is merged. This is not a complete guarantee: a pull request can still edit `scripts/secret-scan.sh` or the workflow, and review is the control for those. A base branch without `.gitleaks.toml` gets the gitleaks built in default rules, never an empty set, and for that run upstream's global allowlist and its path skips apply again.

`scripts/secret-scan.test.sh` plants generated fake keys in throwaway repositories and checks that each one fails: in an ordinary commit, in a commit later deleted, behind `gitleaks:allow`, behind a `.gitleaksignore`, in a merge resolution, in files marked `-diff` or `binary`, in each path upstream skips (lockfiles, `node_modules`, `.svg`, a text `.png`, `.pem`, `.key`, `.log`, `go.sum`, any `gitleaks.toml`), and in a pull request that tries to replace the rules. It checks that key and env files are refused, also when removed later and with non-ASCII names, that `.pub` keys and `.env.example` pass, that delete only, rename only, mode only, binary, symlink and empty commits pass with the commit count matched exactly, and that `.gitleaks.toml` itself holds no key shaped literal. Both scripts run locally once gitleaks is installed (`brew install gitleaks`):

```sh
scripts/secret-scan.sh
scripts/secret-scan.test.sh
```

A manual run of gitleaks must pass the config as an absolute path, as `scripts/secret-scan.sh` does (`--config "$PWD/.gitleaks.toml"`, not `--config .gitleaks.toml`). When a relative config path matches the path of the file inside the repository, gitleaks silently skips findings in the config file itself.

Merging: this repository must stay squash-only. A pull request branch may hold commits, such as test probes or fixups, that never reach `development` only because every merge is a squash merge, and the scan on `development` relies on that. Enabling merge commits or rebase merging requires revisiting the secret scan first.

Keep `.env` files untracked; only `.env.example` belongs in git.

## License

Apache License 2.0. See [LICENSE](LICENSE).
