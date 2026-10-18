# Payouts and split payouts

> **Status:** UJIRA is in development. This page describes how payouts are designed to work. Single payouts, batch payouts and split payouts are all planned.

## What it is

A **payout** is one payment from a mandate to one recipient, for an amount the principal owes them. You ask UJIRA to pay a recipient an amount, and UJIRA turns that request into money in the recipient's account, in their own currency.

You can ask for payouts one at a time, or many at once in a **batch** (for example, everyone you owe for this week).

For each payout, UJIRA:

1. Checks the request against the mandate's rules, and waits for approval if the amount is above the approval threshold. See [Mandates](mandates.md).
2. Pays out on Stellar by the method the recipient chose: USDC straight to their own Stellar wallet, or through a licensed **anchor** that converts to local currency and pays into a bank account, to mobile money or as cash. See [Stellar and payout methods](chains-and-routing.md).
3. Tracks the status until the money arrives, and writes a receipt. See [Receipts](receipts.md).

### Idempotency

Every request that moves money carries an **idempotency key**: a unique value you choose for that payout, such as your own task ID. If the same request arrives twice, for example because your code retried after a network timeout, UJIRA recognises the key and does not pay twice. You can retry safely.

## Why it matters

You integrate once and pay people in many countries without building a payout system for each one. You never choose a payout path, and retries never double-pay anyone.

## Split payouts

A **split payout** lets a recipient take one payout two ways. For example, part in local currency to their bank or mobile money, and part kept in dollars in a wallet they control. Recipients see this option as "Keep in dollars".

The principal still pays one amount. The mandate's caps and approvals apply to the total, and the split never changes what the principal approved. The recipient sets the split, not the principal.

Each part of a payout is called a **leg**. A normal payout has one leg. A split payout has two.

The details in this table are planned and not final.

| Rule | What happens |
| --- | --- |
| Number of legs | At most two: one local-currency method plus "Keep in dollars" |
| Who sets the split | The recipient, as a standing rule: a percentage or a fixed amount. They can change it at any time in the onboarding widget |
| Minimums | If one leg would be below its method's minimum, it merges into the other leg, and the recipient is told why |
| A leg fails | UJIRA retries it, then falls back to the recipient's main method. The status reads "Partly paid" until every leg arrives. Money is never left stuck in between |
| Retries | Each leg has its own idempotency key, made from the payout's key, so a retry never pays a leg twice |
| Fees | Shown per leg on the receipt, never hidden |
| Countries | "Keep in dollars" is offered only where local rules allow holding digital dollars |

A local-currency leg goes through a licensed anchor to the recipient's chosen method, and a "Keep in dollars" leg goes straight to the recipient's own Stellar wallet. UJIRA never holds any part of either.

## Example

A research marketplace owes an expert in Lagos ₦480,000.00. The expert has set a split: keep 30 percent in dollars, send the rest to their bank.

1. The marketplace asks UJIRA to pay ₦480,000.00, with its own task ID as the idempotency key.
2. The amount is above the mandate's approval threshold, so it waits until the marketplace's finance lead approves it.
3. UJIRA splits the payout into two legs: ₦336,000.00 to the expert's bank, and the other 30 percent, ₦144,000.00, as $96.00 at that moment's exchange rate, kept in dollars in the expert's own wallet.
4. Both legs arrive. The status reads "Paid", and one receipt shows the total and each leg.

The marketplace approved and paid one amount. It did nothing different because the expert chose a split.

## Troubleshooting

**My code timed out. Should I retry?** Yes, with the same idempotency key. UJIRA will not pay twice for the same key.

**The status says "Partly paid".** One leg of a split payout has not arrived yet. UJIRA retries it, then falls back to the recipient's main method.

**A recipient did not get the split they asked for.** One leg was probably below its method's minimum and merged into the other leg, or "Keep in dollars" is not offered in their country, so the whole payout went to their main method. When a leg merges because of a minimum, the recipient is told why.

**Which statuses can a payout have?** The full list will be published in the [API reference](../api-reference.md) when the API is final.
