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
- [MCP guide](docs/mcp-guide.md) (Planned): using UJIRA from Claude and other MCP clients
- [Changelog](CHANGELOG.md)

## Checking the docs locally

You need Node.js 20 or later.

```sh
# Lint every Markdown file
npx --yes markdownlint-cli2@0.23.3

# Fail if any file contains an em dash or an en dash
./scripts/check-dashes.sh
```

Both commands exit with code 0 when the docs are clean.

## License

Apache License 2.0. See [LICENSE](LICENSE).
