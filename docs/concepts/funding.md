# Funding

> **Status:** UJIRA is in development. This page describes how funding is designed to work.

## What it is

**Funding** is how a principal puts money into a mandate, so the mandate has something to pay out. (A **mandate** is the set of spending rules that also holds the money. See [Mandates](mandates.md).)

You fund a mandate with a **stablecoin deposit**. A stablecoin is a digital token designed to keep a steady value. UJIRA accepts these dollar stablecoins:

| Network | Accepted assets |
| --- | --- |
| Stellar | USDC |
| Celo | USDC or USDm |

**USDC** is a dollar stablecoin issued by Circle. **USDm** is a dollar stablecoin native to Celo. Stellar and Celo are the two **blockchains** (public networks that record every payment) that UJIRA runs on. See [Chains and routing](chains-and-routing.md).

Each mandate has a **funding address** on each network: the address you deposit to. The dashboard shows each funding address with a QR code, the exact asset and network (for example "USDC on Stellar"), and a warning not to send any other asset or use any other network.

## Why it matters

A stablecoin deposit needs no bank partner and no extra contract. Any company that already holds stablecoins, or can buy them through its own exchange account, can fund a mandate by depositing them to its funding address.

The money goes straight into the mandate, which the principal controls. UJIRA never holds it. See [Security and the non-custodial model](security.md).

## Network fees are handled for you

Every blockchain charges a small **network fee** (often called **gas**) to process a transaction. Normally you pay it in the network's own token: XLM on Stellar, CELO on Celo. UJIRA removes that step, so a principal never needs to buy or hold XLM or CELO.

| Network | What UJIRA does |
| --- | --- |
| Stellar | UJIRA pays the network fee on every transaction you sign through UJIRA: funding, pausing, revoking and approving. It does this with a Stellar feature called a **fee-bump transaction**, where a second account pays the fee for yours. |
| Celo | Celo lets a transaction pay its fee in a stablecoin instead of CELO. Every transaction UJIRA prepares for you pays its fee in the asset you are sending, USDC or USDm, so no CELO is needed. |

There is one Stellar detail to know. If you deposit from your **own** Stellar account (not from an exchange), that account must keep the network's **minimum balance**: about 1.5 XLM in total, made up of a 1 XLM base reserve plus 0.5 XLM for the USDC **trustline** (the setting that lets a Stellar account hold USDC). This is a Stellar network rule, not a UJIRA fee. Deposits sent from an exchange need none of this, because the exchange pays.

## Balances

For each mandate, on each network, the dashboard shows:

- **Balance:** the money in the mandate.
- **Committed:** money for payouts that are approved but not paid yet.
- **Low-balance alerts:** a warning before the mandate runs short.

A deposit counts as available once the network confirms it.

## Example

A grant platform wants to fund a mandate with $50,000.00 from its exchange account.

1. In the dashboard it opens the mandate and copies the funding address marked "USDC on Stellar".
2. In its exchange account it withdraws 50,000 USDC, chooses the Stellar network, and pastes the funding address.
3. Once the Stellar network confirms the deposit, the mandate's balance shows $50,000.00 and payouts can start.

The platform held no XLM and paid no network fee. The exchange paid the fee for its own withdrawal.

## Troubleshooting

**My deposit does not show yet.** A deposit becomes available only after the network confirms it. Check the transaction on a public Stellar or Celo explorer (a website that shows every transaction on the network) using the transaction ID from your exchange or wallet.

**I sent the wrong asset or used the wrong network.** Only the assets in the table above, on the network shown next to the funding address, are accepted. Always copy the funding address for the exact asset and network you are sending. What can be recovered after a wrong deposit is not documented yet.

**Can I fund from a bank account?** No. Stablecoin deposits are the only planned way to fund a mandate. Any new way to fund will be announced in the [changelog](../../CHANGELOG.md).

**My Stellar wallet says I do not have enough XLM.** Your own Stellar account needs the minimum balance described above before it can hold and send USDC. Withdrawing from an exchange avoids this.
