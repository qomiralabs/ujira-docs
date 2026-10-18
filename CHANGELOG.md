# Changelog

All notable changes to UJIRA that affect integrators, and to these docs, are recorded in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Docs map in the README.
- Concept pages: what UJIRA is, mandates, funding, payouts and split payouts, receipts, recipient onboarding and the embed widget, Stellar and payout methods, and security and the non-custodial model.
- Glossary of the terms used across the docs.
- Placeholder pages, marked Planned, for the API reference and the MCP guide.
- Markdown lint configuration and a script that fails on em and en dashes.
- A link check script, with a self test, that fails when a relative link or heading link does not resolve.
- A check, with a self test, that the glossary is in alphabetical order.

### Changed

- The docs describe UJIRA as settling on Stellar only. Payouts reach people as USDC in their own Stellar wallet, or as local currency in a bank account, to mobile money or as cash through licensed anchors. Funding is USDC on Stellar.
- The payouts page says which methods pay local currency and which pays USDC, that the recipient receives the full dollar amount, that anchor cash-out costs apply only when converting, and that activation, including a missing USDC trustline, is free for recipients.
- The glossary is in alphabetical order.

### Fixed

- The link check accepts headings that contain inline code and percent-encoded paths.

[Unreleased]: https://github.com/qomiralabs/ujira-docs/commits/development
