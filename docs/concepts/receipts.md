# Receipts

> **Status:** UJIRA is in development. This page describes how receipts are designed to work.

## What it is

A **receipt** is the permanent record of one payout. UJIRA writes one for every payout, and you can export them.

A receipt for the principal carries:

| Item | What it means |
| --- | --- |
| Task ID | Your own reference for the work being paid for |
| Amount and currency | How much was paid, in which currency |
| Recipient reference | Which recipient was paid |
| Mandate | Which mandate the money came from |
| Network | Stellar, the blockchain every payout settles on |
| Transaction hash | The unique ID of the payment on Stellar |

A **transaction hash** is like a tracking number that the network itself issues. Anyone can look it up on a public **block explorer** (a website that shows every transaction on a network) and see that the payment happened, when, and for how much. You do not have to take UJIRA's word for it. For a local-currency payout, the hash records the payment on Stellar to the licensed anchor that paid the recipient.

A split payout (see [Payouts and split payouts](payouts.md)) still has **one** receipt. It shows the total, then each leg with its method, amount, currency, fee and transaction hash.

Recipients see their own version of the receipt. It shows who paid them, how much and when. A local-currency payout shows only the recipient's own currency. A payout to their Stellar wallet shows the amount in USDC.

## Why it matters

- **For principals:** a receipt is proof for your accounting and audits that a specific person was paid a specific amount for a specific task, from a specific mandate.
- **For recipients:** a receipt is proof of income they can keep and share.
- **For everyone:** the transaction hash makes every payout independently checkable. Fees are shown, never hidden.

The table above describes what a receipt contains; it does not name API fields. The exact export format will be published in the [API reference](../api-reference.md).

## Example

The expert in Lagos from the [split payout example](payouts.md#example) gets one receipt that reads:

> ₦480,000.00 paid: ₦336,000.00 to bank, 96.00 USDC to your Stellar wallet

The research marketplace's copy of the same receipt also shows the task ID, the mandate, the fee on each leg, and a Stellar transaction hash for each leg.

## Troubleshooting

**I cannot find a transaction on the explorer.** Make sure you are using a Stellar explorer for the live network, not a test network, and that you copied the whole hash.

**A split payout shows two transaction hashes.** That is expected. Each leg is its own payment on the network, so each has its own hash.

**A recipient asks why their receipt does not mention Stellar.** They chose a local-currency method, so their receipt shows only their own currency. Receipts for "USDC to your Stellar wallet" payouts name USDC and Stellar.
