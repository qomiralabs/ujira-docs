# Chains and routing

> **Status:** UJIRA is in development. This page gives a high-level view of how routing is designed to work.

## What it is

UJIRA settles payouts on two **blockchains**, public networks that record every payment so anyone can check it: **Stellar** and **Celo**. People often call a blockchain a **chain**. Both are core to UJIRA, and neither is a backup for the other.

The **router** is the part of UJIRA that picks which chain a payout uses. It decides per **corridor**: the route money takes to reach a recipient in a given country, with a given payout method.

You never pick a chain. You send one payout request, and the router chooses.

## Why it matters

No single chain does everything a payout needs.

- **Stellar** connects to licensed payout services that turn dollars into local money in a bank account or e-wallet, and to cash pickup in many countries.
- **Celo** has local-currency stablecoins (digital tokens that track a local currency, such as the Kenyan shilling) and mobile wallets that many people in UJIRA's first countries already use.

Choosing one chain would mean giving up half of what makes a payout land. With both, UJIRA can pick whichever chain gets local money to that person fastest and cheapest.

## How the router decides

For each payout, the router follows these steps in order:

1. If the recipient's payout method or country has a local-currency stablecoin or wallet on **Celo**, prefer Celo.
2. Otherwise, if a licensed payout service on **Stellar** covers the country with local bank payout or cash pickup, use Stellar.
3. If both chains serve the corridor, pick the cheaper and faster one at that moment. If one is having problems, fall back to the other.

Coverage changes as new countries and methods open on each chain, so UJIRA updates its routing settings without needing a new release. Your integration does not change when coverage grows.

## Example

A platform pays two people on the same day:

- A recipient in Kenya who takes mobile money. A shilling stablecoin exists on Celo, so the router pays through Celo.
- A recipient who chose cash pickup. Cash pickup is reached through Stellar, so the router pays through Stellar.

The platform sent two payout requests in exactly the same way. Each receipt shows the chain that settled it, so the platform can verify each payment on the right network.

## Troubleshooting

**Can I force a payout onto one chain?** No. Routing is UJIRA's job, so your integration stays the same as coverage changes.

**Which countries are covered?** The list of supported countries and methods is not published yet. It will be added to these docs.

**Do recipients see which chain was used?** No. Recipient screens and receipts never mention chains. Only principals see the settling chain, on their receipts and in the dashboard.
