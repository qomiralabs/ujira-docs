# What UJIRA is

> **Status:** UJIRA is in development. This page describes how it is designed to work.

## What it is

UJIRA is a payout rail. A payout rail is the system that moves money from the business that owes it to the person who earned it. UJIRA pays people for their work, in their own local currency, under rules a human sets in advance.

There are two sides:

- A **principal** is the business that pays. It might be a data platform paying annotators, a bounty board paying winners, or a research marketplace paying experts.
- A **recipient** is the person who gets paid. They might live in Lagos, Nairobi, Manila or Sao Paulo, and they want the money in naira, shillings, pesos or reais, not in a currency they have to convert themselves.

A principal can pay through UJIRA in three ways:

1. From the **dashboard**, a planned web app where a person sets rules, adds money and watches payouts. Its details are not final.
2. From its own code, through the **API** (application programming interface).
3. Through an **agent**: software that acts for the principal, such as an AI agent that reviews finished tasks and pays for them. The agent holds a key that lets it ask for payouts, but only inside the limits the principal set.

All three use the same payout system underneath.

## Why it matters

Paying a person in another country is slow and expensive today. A contributor can wait days and lose part of the payment to fees and currency conversion. The platform paying them carries the support burden.

Agents make this harder. An agent can already pay for an API or for compute, but there has been no safe way for it to pay a person in local currency without giving it open access to a bank account.

UJIRA solves both problems with three ideas:

- **Mandates.** The principal sets spending rules once: a total budget, a cap per payment, a cap per person per day, who can be paid, when a human must approve, and when the rules expire. An agent cannot pay outside them. See [Mandates](mandates.md).
- **Non-custodial by design.** UJIRA never holds the principal's money. The money sits in a mandate the principal controls, and goes from there to the recipient. See [Security and the non-custodial model](security.md).
- **A receipt for every payout.** Every payout produces a receipt that anyone can check against a public record. See [Receipts](receipts.md).

## How a payout flows

1. The principal creates a mandate with its rules.
2. The principal adds money to the mandate with a stablecoin deposit. A **stablecoin** is a digital token designed to keep a steady value, usually one US dollar. See [Funding](funding.md).
3. The principal invites a recipient, who verifies their identity once and picks how they want to be paid, for example a bank account or mobile money. See [Recipient onboarding](recipient-onboarding.md).
4. The principal, or its agent, asks UJIRA to pay that recipient an amount.
5. The mandate checks the rules. If the amount is above the approval threshold, a named person must approve it first.
6. UJIRA pays out on Stellar: straight to the recipient's own wallet, or through a licensed anchor that pays local currency. See [Stellar and payout methods](chains-and-routing.md).
7. The recipient receives local currency, or dollars if they chose to keep them, and both sides get a receipt.

## Example

A data platform pays 200 annotators in several countries every Friday.

- It creates one mandate with a weekly budget of $10,000.00, a cap of $200.00 per payment, and an approval threshold of $150.00.
- It deposits $10,000.00 in USDC, a dollar stablecoin, into the mandate.
- Its review agent pays each annotator for approved tasks. Payments of $150.00 or less go straight through. A $180.00 bonus waits until a person on the finance team approves it.
- One annotator receives local currency by mobile money. Another keeps the payout in dollars in their own wallet. Each payout has a receipt.

The platform never chose a payout path, never built a payout system per country, and never handed its agent open access to its money.

## Troubleshooting

**Is UJIRA an app for recipients?** No. UJIRA is infrastructure that platforms build on. Recipients meet UJIRA only through the onboarding widget inside the platform they work with, and through their receipts.

**Can I use UJIRA today?** Not yet. Watch the [changelog](../../CHANGELOG.md) for the first release.

**Where are the API details?** The [API reference](../api-reference.md) is planned. It will be published when the API is final.
