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
- [Funding](docs/concepts/funding.md): how you put money into a mandate with a stablecoin deposit, and why you never need to hold network tokens for fees
- [Payouts and split payouts](docs/concepts/payouts.md): how a payout becomes money in a person's account, and how a recipient can take one payout two ways
- [Receipts](docs/concepts/receipts.md): the permanent, verifiable proof of every payout
- [Recipient onboarding and the embed widget](docs/concepts/recipient-onboarding.md): how a person becomes payable, inside your own product
- [Chains and routing](docs/concepts/chains-and-routing.md): why UJIRA runs on Stellar and Celo, and how it picks one for each payout
- [Security and the non-custodial model](docs/concepts/security.md): who holds the money at each step, and what protects it

### Reference

- [API reference](docs/api-reference.md) (Planned)
- [MCP guide](docs/mcp-guide.md) (Planned): using UJIRA from an MCP client such as a desktop AI assistant or IDE agent
- [Changelog](CHANGELOG.md)

## Checking the docs locally

You need Node.js 20 or later.

```sh
# Lint every Markdown file
npx --yes markdownlint-cli2@0.23.3

# Fail if any file contains an em dash or an en dash
./scripts/check-dashes.sh

# Self test for the dash check
./scripts/test-check-dashes.sh

# Fail if any file contains a literal invisible or bidirectional control character
./scripts/check-invisible-characters.py

# Self test for the invisible character check
./scripts/test-check-invisible-characters.sh
```

All five commands exit with code 0 when the docs are clean. The invisible character check needs Python 3 and uses its standard library only.

## Invisible characters

Literal bidirectional controls and invisible characters can make text read differently from what it is, and they do not show in review. To check the tree:

```sh
scripts/check-invisible-characters.py
```

It reads every tracked file as bytes. Only files whose extension is on the short binary list in the script (`png`, `jpg`, `jpeg`, `gif`, `webp`, `ico`, `woff`, `woff2`, `wasm`, `pdf`) are skipped, and only when their content starts with that format's signature; a listed name with other content fails. Every other file must be valid UTF-8 and is checked in full, and a NUL byte is reported as U+0000, so a NUL cannot make a source file skip the check. It fails on every character in the Unicode categories Cf, Zl and Zp, such as the byte order mark, zero width characters, the bidirectional controls U+202A to U+202E and U+2066 to U+2069, and U+2028 and U+2029, naming the file, line, column and code point. Categories come from Python's `unicodedata` tables, and the script uses the standard library only. It also fails on the no break space (U+00A0), narrow no break space (U+202F) and minus sign (U+2212), except in files listed in `scripts/invisible-characters-allowlist.txt`. Write any of these as an HTML entity such as `&nbsp;` or `&#x2212;`, or as an escape inside code. `scripts/test-check-invisible-characters.sh` tests the check itself.

## Continuous integration

`.github/workflows/ci.yml` runs on every pull request and on pushes to `development`, `staging` and `main`, with read-only permissions. Its `secrets` job lints the workflows with actionlint and runs the secret scan below. Every action is pinned to a full commit SHA, and actionlint and gitleaks are release binaries checked against a SHA-256 in the workflow; bump a version and its hash together.

## Secret scanning

The `secrets` job in `.github/workflows/ci.yml` runs `scripts/secret-scan.sh` with gitleaks 8.30.1 (MIT licensed), downloaded from its GitHub release and checked against a pinned SHA-256. It checks out the full history and scans every commit reachable from the checked out commit, not only the change, so a key that was committed and later deleted still fails. The scan refuses a shallow clone, and fails unless gitleaks reports scanning as many commits as `git log --no-merges HEAD` lists with file changes (merge commits have no diff of their own). Findings are redacted in the log.

`.gitleaks.toml` extends the default gitleaks rules. Inline `gitleaks:allow` comments are ignored and any `.gitleaksignore` fails the scan, so the config is the only allowlist. Each allowlist entry must cover a single synthetic test fixture and say why it is safe; path wide and rule wide exclusions are not allowed. `scripts/secret-scan.test.sh` plants generated fake keys in throwaway repositories, including one deleted in a later commit, and checks that every one fails the scan.

Both run locally once gitleaks is installed (`brew install gitleaks`):

```sh
scripts/secret-scan.sh
scripts/secret-scan.test.sh
```

Keep `.env` files untracked; only `.env.example` belongs in git.

## License

Apache License 2.0. See [LICENSE](LICENSE).
