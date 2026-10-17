# Funding

> **Status:** UJIRA is in development. This page describes how funding is designed to work. Dashboard details on this page are not final.

## What it is

**Funding** is how a principal puts money into a mandate, so the mandate has something to pay out. (A **mandate** is the set of spending rules that also holds the money. See [Mandates](mandates.md).)

You fund a mandate with a **stablecoin deposit**. A stablecoin is a digital token designed to keep a steady value. UJIRA accepts these dollar stablecoins:

| Network | Accepted assets |
| --- | --- |
| Stellar | USDC |
| Celo | USDC or USDm |

**USDC** is a dollar stablecoin issued by Circle. **USDm** is a dollar stablecoin native to Celo. Stellar and Celo are the two **blockchains** (public networks that record every payment) that UJIRA runs on. See [Chains and routing](chains-and-routing.md).

Each mandate has a **funding address** on each network: the mandate's own address, which deposits go into. How you deposit depends on the network:

- **On Stellar,** you deposit from your own Stellar account into the mandate, through UJIRA. Exchanges cannot pay a mandate's address on Stellar directly, so money withdrawn from an exchange goes to your own Stellar account first, then into the mandate.
- **On Celo,** you deposit USDC or USDm to the mandate's funding address from your wallet.

The dashboard is planned to show each funding address with the exact asset and network (for example "USDC on Stellar"), and a warning not to send any other asset or use any other network.

## Why it matters

A stablecoin deposit needs no bank partner and no extra contract. Any company that already holds stablecoins, or can buy them through its own exchange account, can fund a mandate by depositing them into it.

The money goes straight into the mandate, which the principal controls. UJIRA never holds it. See [Security and the non-custodial model](security.md).

## Network fees

Every blockchain charges a small **network fee** (often called **gas**) to process a transaction. Normally you pay it in the network's own token: XLM on Stellar, CELO on Celo. With UJIRA, you never need XLM or CELO to pay network fees, and you never need CELO at all.

| Network | Who pays the network fee |
| --- | --- |
| Stellar | UJIRA sponsors the fee on every transaction you sign through UJIRA: funding, pausing, revoking and approving. It uses a Stellar feature called a **fee-bump transaction**, where a second account pays the fee for yours. |
| Celo | The fee is paid in USDC or USDm, using Celo's **fee currency** feature, which lets a transaction pay its fee in a stablecoin instead of CELO. Every transaction UJIRA prepares for you pays its fee in the asset you are sending. |

### The Stellar minimum balance

Fees are not the only Stellar rule. Every Stellar account must keep a **minimum balance** of XLM: about 1.5 XLM for an account that holds USDC, made up of a 1 XLM base reserve plus 0.5 XLM for the USDC **trustline** (the setting that lets a Stellar account hold USDC). This is a network rule, not a UJIRA fee, and the XLM stays in your account. Because Stellar deposits come from your own Stellar account, that account needs this minimum balance.

## Balances

The dashboard is planned to show, for each mandate on each network:

- **Balance:** the money in the mandate.
- **Committed:** money for payouts that are approved but not paid yet.
- **Low-balance alerts:** a warning before the mandate runs short.

A deposit counts as available once the network confirms it.

## Example

A grant platform wants to fund a mandate on Stellar with $50,000.00 that it holds on an exchange.

1. In its exchange account, it withdraws 50,000 USDC on the Stellar network to its own Stellar account. That account already holds the minimum balance and a USDC trustline.
2. Through UJIRA, it signs a deposit of 50,000 USDC from its own Stellar account into the mandate. UJIRA sponsors the network fee for this transaction.
3. Once the Stellar network confirms the deposit, the mandate's balance shows $50,000.00 and payouts can start.

The platform paid no network fee for the deposit into the mandate. The only XLM involved is the minimum balance that stays in its own account.

## Troubleshooting

**My deposit does not show yet.** A deposit becomes available only after the network confirms it. Check the transaction on a public Stellar or Celo explorer (a website that shows every transaction on the network) using the transaction ID from your wallet.

**My exchange will not withdraw to the mandate on Stellar.** That is expected. Withdraw to your own Stellar account first, then deposit from that account into the mandate.

**I sent the wrong asset or used the wrong network.** Only the assets in the table above, on the network they are listed for, are accepted. What can be recovered after a wrong deposit is not documented yet.

**Can I fund from a bank account?** No. Stablecoin deposits are the only planned way to fund a mandate. Any new way to fund will be announced in the [changelog](../../CHANGELOG.md).

**My Stellar wallet says I do not have enough XLM.** Your own Stellar account needs the minimum balance described above before it can hold USDC. Add enough XLM to cover it. UJIRA still sponsors the network fee on transactions you sign through UJIRA.
