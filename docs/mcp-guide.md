# MCP guide

> **Planned.** The UJIRA MCP server is not built yet. This guide will explain how to set it up and use it once it is released. Until then it lists only what is already decided, and shows no tool names, settings or example output.

## What it is

**MCP** (Model Context Protocol) is an open standard that lets an AI application connect to outside tools and data. An application that speaks MCP is called an **MCP client**. An MCP client might be a desktop AI assistant or an IDE agent; there are many others.

UJIRA will ship an **MCP server**: a small service that lets any MCP client work with UJIRA. Through it, an agent or a person chatting with an MCP client will be able to request payouts, check their status and read receipts.

## Why it matters

An agent that already uses MCP can pay people through UJIRA without custom integration code. It can only act inside the mandate it was given, exactly as if it were calling the API.

## What is already decided

- **The same guardrails apply everywhere.** The MCP server uses the same payout system as the dashboard and the [API](api-reference.md), so the same [mandate](concepts/mandates.md) rules and approvals apply.
- **Reading is open; paying is gated.** Actions that only read, such as checking a payout's status or reading a receipt, are open to a connected client. Actions that move money are gated by the mandate's rules and its approvals.
- **The chain is hidden.** As with the API, the router picks the chain. See [Chains and routing](concepts/chains-and-routing.md).

## Example

There is no example yet. This guide will include a tested setup for common MCP clients, such as a desktop AI assistant or an IDE agent, when the server is released.

## Troubleshooting

**When will the MCP server be available?** Watch the [changelog](../CHANGELOG.md).
