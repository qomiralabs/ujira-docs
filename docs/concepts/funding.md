# Funding

> **Status:** UJIRA is in development. This page describes how funding is designed to work. Dashboard details on this page are not final.

## What it is

**Funding** is how a principal puts money into a mandate, so the mandate has something to pay out. (A **mandate** is the set of spending rules that also holds the money. See [Mandates](mandates.md).)

You fund a mandate with a **stablecoin deposit**: **USDC on Stellar**. A stablecoin is a digital token designed to keep a steady value. **USDC** is a dollar stablecoin issued by Circle. **Stellar** is the **blockchain** (a public network that records every payment) that UJIRA runs on. See [Stellar and payout methods](chains-and-routing.md).

Each mandate has a **funding address**: the mandate's own address on Stellar, which deposits go into. You deposit from your own Stellar account into the mandate, through UJIRA. Exchanges cannot pay a mandate's address on Stellar directly, so money withdrawn from an exchange goes to your own Stellar account first, then into the mandate.

The dashboard is planned to show the funding address with the exact asset and network ("USDC on Stellar"), and a warning not to send any other asset or use any other network.

## Why it matters

A stablecoin deposit needs no bank partner and no extra contract. Any company that already holds stablecoins, or can buy them through its own exchange account, can fund a mandate by depositing them into it.

The money goes straight into the mandate, which the principal controls. UJIRA never holds it. See [Security and the non-custodial model](security.md).

## Network fees

Every blockchain charges a small **network fee** (often called **gas**) to process a transaction. On Stellar you would normally pay it in XLM, Stellar's own token. With UJIRA, a principal never needs XLM.

UJIRA sponsors the fee on every transaction you sign through UJIRA: funding, pausing, revoking and approving. It uses a Stellar feature called a **fee-bump transaction**, where a second account pays the fee for yours.

### The Stellar minimum balance

Fees are not the only Stellar rule. Every Stellar account must keep a **minimum balance** of XLM, called **reserves**: a 1 XLM base reserve plus 0.5 XLM for the USDC **trustline** (the setting that lets a Stellar account hold USDC). You still never need XLM:

- **If you already have a Stellar account that holds USDC,** it already meets this minimum.
- **If you do not,** UJIRA sets up a Stellar funding account that you own and control, and sponsors its minimum balance and trustline reserves using Stellar's **sponsored reserves** feature, where another account covers an account's reserves. UJIRA covers the reserves only; it never holds your funds.

## Balances

The dashboard is planned to show, for each mandate:

- **Balance:** the money in the mandate.
- **Committed:** money for payouts that are approved but not paid yet.
- **Low-balance alerts:** a warning before the mandate runs short.

A deposit counts as available once the network confirms it.

## Example

A grant platform wants to fund a mandate on Stellar with $50,000.00 that it holds on an exchange.

1. The platform has no Stellar account yet, so UJIRA sets up a Stellar funding account that the platform owns and controls, and sponsors its reserves.
2. In its exchange account, the platform withdraws 50,000 USDC on the Stellar network to that funding account.
3. Through UJIRA, it signs a deposit of 50,000 USDC from its funding account into the mandate. UJIRA sponsors the network fee for this transaction.
4. Once the Stellar network confirms the deposit, the mandate's balance shows $50,000.00 and payouts can start.

The platform never held any XLM. UJIRA sponsored the reserves of its funding account and the network fee for the deposit, and never held the platform's funds.

## Troubleshooting

**My deposit does not show yet.** A deposit becomes available only after the network confirms it. Check the transaction on a public Stellar explorer (a website that shows every transaction on the network) using the transaction ID from your wallet.

**My exchange will not withdraw to the mandate on Stellar.** That is expected. Withdraw to your own Stellar account first, then deposit from that account into the mandate.

**I sent the wrong asset or used the wrong network.** Only USDC on Stellar is accepted. What can be recovered after a wrong deposit is not documented yet.

**Can I fund from a bank account?** No. Stablecoin deposits are the only planned way to fund a mandate. Any new way to fund will be announced in the [changelog](../../CHANGELOG.md).

**My Stellar wallet says I do not have enough XLM.** You should not need any. If your Stellar account does not hold USDC yet, use the Stellar funding account UJIRA sets up for you, whose reserves UJIRA sponsors. UJIRA also sponsors the network fee on transactions you sign through UJIRA.
