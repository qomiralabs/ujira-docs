# API reference

> **Planned.** The UJIRA API is not built yet. This page will hold the full reference once the API is final. Until then it lists only what is already decided, and shows no endpoints, request formats or response formats.

## What it is

The **API** (application programming interface) is how your own code talks to UJIRA. It is a **REST** API: your code sends HTTPS requests to UJIRA and gets structured answers back. With it you will be able to request payouts, check their status and read receipts. The chain is chosen for you by the router, so the API never asks you to pick one. See [Chains and routing](concepts/chains-and-routing.md).

The dashboard, the API and the [MCP server](mcp-guide.md) all use the same payout system, so the same mandate rules and approvals apply whichever one you use.

## Why it matters

The API is how platforms and agents automate payouts: paying many people on a schedule, paying as soon as a task is approved, and keeping their own records in step with UJIRA's receipts.

## What is already decided

- **Amounts are never decimals that can round.** Every amount is a whole number in the currency's **minor units** (the smallest unit, such as cents for dollars or kobo for naira), always with an explicit currency. For example, $12.50 is 1250 minor units of US dollars.
- **Every request that moves money carries an idempotency key**, so a retried request is never paid twice. See [Payouts and split payouts](concepts/payouts.md#idempotency).
- **Payouts are made of one or more legs** from the start. A normal payout has one leg; a split payout has two.
- **Webhooks and streaming status are planned after launch.** A **webhook** is a message UJIRA sends to your server when something changes, such as a payout being paid, so you do not have to keep asking.
- **The reference will be generated from the API's machine-readable description**, so the docs and the API cannot drift apart.

## Example

There is no example yet. Every request and response on this page will come with a tested example when the API is published.

## Troubleshooting

**When will the API be available?** Watch the [changelog](../CHANGELOG.md).

**Can I build against it now?** Not yet. You can read the [concept pages](../README.md#concepts) to plan your integration in the meantime.
