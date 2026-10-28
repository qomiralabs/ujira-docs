# Glossary

## What it is

Every term used in these docs, explained in plain English. Each concept page also explains a term the first time it uses it.

## Why it matters

Payments and blockchains come with a lot of jargon. If a word on any page is unclear, look it up here.

## Terms

**Agent.** Software that acts for a principal, such as an AI agent that reviews finished tasks and pays for them. An agent holds a key that can only ask a mandate for payouts inside its rules.

**Anchor.** A licensed business that connects the Stellar network to local money. It receives a digital dollar on Stellar and pays the recipient in local currency, into a bank account, to mobile money or as cash. See [Stellar and payout methods](concepts/chains-and-routing.md).

**API (application programming interface).** The way your own code talks to UJIRA. See [API reference](api-reference.md).

**Approval threshold.** The amount above which a named person must approve a payout before it runs. See [Mandates](concepts/mandates.md#approvals).

**Audit log.** A permanent list of who did what and when, such as every approval decision.

**Batch.** Many payouts requested together, such as everyone you owe this week.

**Block explorer.** A public website that shows every transaction on a blockchain. You can look up a receipt's transaction hash there.

**Blockchain, or chain.** A public network that records every payment so anyone can check it. UJIRA uses Stellar.

**Corridor.** The route money takes to reach a recipient in a given country, with a given payout method.

**Custodial and non-custodial.** A custodial service holds your money in its own account. UJIRA is non-custodial: it never holds the principal's money. See [Security](concepts/security.md).

**Embed widget.** The ready-made onboarding screen you add to your own product. See [Recipient onboarding](concepts/recipient-onboarding.md).

**Fee-bump transaction.** A Stellar feature that lets a second account pay the network fee for your transaction. UJIRA uses it to sponsor Stellar fees.

**Funding address.** A mandate's own address on Stellar, which deposits go into. On Stellar you deposit into it from your own Stellar account, not straight from an exchange.

**Gas, or network fee.** The small fee a blockchain charges to process a transaction.

**Idempotency key.** A unique value you attach to a request that moves money. If the same request arrives twice, UJIRA pays only once.

**KYC (know your customer).** The identity checks licensed payment services must run before paying someone.

**Leg.** One part of a payout, sent to one payout method. A normal payout has one leg; a split payout has two.

**Mainnet.** The live version of a blockchain, where real money moves. Its opposite is a test network.

**Mandate.** The set of spending rules a principal writes once, which also holds the money those rules spend. See [Mandates](concepts/mandates.md).

**MCP (Model Context Protocol).** An open standard that lets AI applications connect to outside tools. See [MCP guide](mcp-guide.md).

**Minimum balance and reserve.** On Stellar, an amount of XLM an account must keep, counted in base reserves of 0.5 XLM each: two base reserves (1 XLM) for the account itself, plus one more for each asset it holds, such as a USDC trustline. It is not a fee. UJIRA sponsors these reserves for the Stellar funding account it sets up for a principal, so principals never need XLM.

**Minor units.** The smallest unit of a currency, such as cents for US dollars or kobo for naira. UJIRA counts money in whole minor units so amounts never round.

**Payout.** One payment from a mandate to one recipient. See [Payouts](concepts/payouts.md).

**Principal.** The business that pays, and that owns the mandate.

**Receipt.** The permanent, verifiable record of one payout. See [Receipts](concepts/receipts.md).

**Recipient.** The person who gets paid.

**Reporting time zone.** The time zone, set on the principal's account, that reports group figures into. It never changes a cap: caps count the UTC day. See [How UJIRA counts days](concepts/how-ujira-counts-days.md).

**Routing configuration.** The list, kept by UJIRA, of which anchors serve which countries and payout methods. See [Stellar and payout methods](concepts/chains-and-routing.md).

**Smart contract.** A small program that runs on a blockchain and enforces its rules for everyone.

**Split payout.** One payout that the recipient takes two ways, such as part to their bank and part as USDC to their own Stellar wallet. See [Split payouts](concepts/payouts.md#split-payouts).

**Sponsored reserves.** A Stellar feature that lets one account cover another account's minimum balance. The sponsored account still belongs to its owner.

**Stablecoin.** A digital token designed to keep a steady value, usually one US dollar. UJIRA accepts USDC on Stellar.

**Transaction hash.** The unique ID a blockchain gives a payment, like a tracking number anyone can look up.

**Trustline.** A Stellar account setting that lets the account hold a specific asset, such as USDC.

**UTC day.** A calendar day on the UTC clock, running 00:00 to 23:59 UTC. The per-person daily cap counts this day, whatever the reporting time zone is. See [How UJIRA counts days](concepts/how-ujira-counts-days.md).

**Webhook.** A message UJIRA will send to your server when something changes, such as a payout being paid. Planned.

## Example

The sentence "The agent requested a payout with an idempotency key, and an anchor paid the recipient in local currency" means: the software acting for the business asked to pay someone, attached a unique value so a retry could not pay twice, and a licensed business on Stellar turned the digital dollars into the recipient's own currency.

## Troubleshooting

**A term is missing.** Open an issue in this repository with the term and the page where you found it.
