# Mandates

> **Status:** UJIRA is in development. This page describes how mandates are designed to work. The mandate contracts are not live yet, and dashboard details are not final.

## What it is

A **mandate** is a set of spending rules that the principal writes once and that every payout must follow. It also holds the money those payouts spend. (The **principal** is the business that pays.)

A mandate lives on a blockchain as a **smart contract**: a small program that runs on the network and enforces its rules for everyone, including UJIRA. Nobody can make it pay outside its rules, not the agent, not the platform's code and not UJIRA.

A mandate has these rules:

| Rule | What it controls |
| --- | --- |
| Total budget | The most the mandate can ever pay out |
| Per-payment cap | The most any single payout can be |
| Per-person daily cap | The most one recipient can be paid in one day |
| Allowed recipients or countries | Who can be paid, by name or by country |
| Approval threshold | The amount above which a named person must approve a payout before it runs |
| Expiry | The date after which the mandate stops paying |

The principal can also **pause** a mandate (stop all payouts until it is resumed) or **revoke** it (end it for good) at any time.

## Why it matters

A mandate is what makes it safe to let software pay people. An **agent**, the software that acts for a principal, holds a key that can only ask the mandate for payouts. The key cannot change the rules, cannot raise the budget, and cannot pay anyone outside the allowed list. If the key leaks, the most it can do is ask for payouts the rules already allow, and the principal can pause the mandate at once.

The same rules apply on both networks UJIRA uses, Stellar and Celo. UJIRA keeps two versions of the mandate contract, one for each network, built from one specification and reviewed together, so a rule means the same thing wherever a payout settles. You write the rules once and never think about which network a payout used.

## Approvals

**Approvals** are the human check above the threshold.

- A payout at or below the approval threshold goes straight through, as long as every other rule allows it.
- A payout above the threshold waits. A named approver must sign off, in the dashboard or through the API, before it runs.
- Every approval decision is written to an **audit log**: a permanent list of who did what and when.

## Example

A bounty platform runs a hackathon with $25,000.00 in prizes. It creates this mandate:

| Rule | Value |
| --- | --- |
| Total budget | $25,000.00 |
| Per-payment cap | $5,000.00 |
| Per-person daily cap | $5,000.00 |
| Allowed recipients | The 40 people registered for the hackathon |
| Approval threshold | $1,000.00 |
| Expiry | 30 days after the event ends |

What happens next:

- The platform's judging agent pays a $500.00 prize to a winner. It is under the threshold, so it is paid at once.
- The agent asks to pay the $5,000.00 grand prize. It is above the threshold, so it waits until the head of the platform approves it.
- The agent asks to pay $6,000.00 to one person. The mandate refuses, because it breaks the per-payment cap.
- The agent asks to pay someone who did not register. The mandate refuses, because they are not on the allowed list.
- After 30 days the mandate expires and pays nothing more.

## Troubleshooting

**A payout was refused.** Check it against each rule in the table above: the amount against the per-payment cap, the recipient's total for the day against the per-person daily cap, the recipient against the allowed list, the mandate's remaining budget, and the expiry date. Also check that the mandate is not paused or revoked.

**A payout is waiting.** It is probably above the approval threshold. A named approver needs to approve it.

**Can the agent change the rules?** No. The agent's key can only ask for payouts inside the rules. How a principal changes a rule will be documented with the API.

**What happens to money left in a revoked or expired mandate?** This will be documented when the mandate contracts are final.
