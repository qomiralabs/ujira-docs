# Stellar and payout methods

> **Status:** UJIRA is in development. This page gives a high-level view of how payouts reach people.

## What it is

UJIRA settles every payout on **Stellar**, a public **blockchain**: a network that records every payment so anyone can check it. People often call a blockchain a **chain**.

From Stellar, a payout reaches the recipient in one of two ways:

| Payout method | How it works |
| --- | --- |
| Dollars to the recipient's own Stellar wallet | UJIRA pays USDC, a dollar stablecoin, straight to a Stellar wallet the recipient controls. Recipients see this as "Keep in dollars". |
| Local currency to bank, mobile money or cash | UJIRA pays USDC to a licensed **anchor**, which pays the recipient in their local currency: into a bank account, to mobile money, or as cash. |

An **anchor** is a licensed business that connects the Stellar network to local money. It receives a digital dollar on Stellar and pays out the local currency on the other side, under the rules of the country it is licensed in. Anchors also run the identity checks the law requires before they pay someone.

## Why it matters

You integrate once and do not build a connection to each country's banks or mobile money services. Stellar was built for payments: transactions settle in seconds for a fraction of a cent, and anchors give it a standard way to reach local money.

You never deal with Stellar directly to pay someone. You send one payout request, and UJIRA delivers it by the method the recipient chose.

## How UJIRA chooses the path

The recipient picks the method during [onboarding](recipient-onboarding.md). UJIRA then picks the path for that method, from its **routing configuration**: a list, kept by UJIRA, of which anchors serve which countries and methods.

A **corridor** is the route money takes to reach a recipient in a given country, with a given payout method. Coverage grows as anchors add countries and methods, and UJIRA updates its routing configuration without needing a new release. Your integration does not change when coverage grows.

Which countries and methods are available is not published yet. Countries and methods named in these docs are examples only, not a statement of coverage.

## Example

A platform pays two people on the same day, with two payout requests sent in exactly the same way:

- A recipient who chose "Keep in dollars" receives USDC straight in their own Stellar wallet.
- A recipient who chose mobile money receives local currency from a licensed anchor that serves their country.

Both payouts settle on Stellar, and each receipt carries the Stellar transaction hash, so the platform can check each payment on the network.

## Troubleshooting

**Can I choose the anchor for a payout?** No. Choosing the path is UJIRA's job, so your integration stays the same as coverage changes.

**Which countries are covered?** The list of supported countries and methods is not published yet. It will be added to these docs.

**Do recipients see Stellar or USDC?** No. Recipient screens and receipts never mention the network or USDC. They see their own currency, or "Keep in dollars". Only principals see the network details, on their receipts.
