# Security and the non-custodial model

> **Status:** UJIRA is in development. This page describes the security model UJIRA is built around. The mandate contracts are not live yet.

## What it is

**Non-custodial** means UJIRA never takes control of the principal's money. A service is **custodial** when it holds your money in its own account and pays from there, so you must trust it not to lose or misuse it. UJIRA is built so that you do not have to.

Here is who holds the money at each step:

| Step | Where the money is |
| --- | --- |
| Before funding | In the principal's own wallet or exchange account |
| After funding | In the principal's mandate, under the mandate's rules |
| During a payout | Moving from the mandate to the recipient's payout method, through a licensed payout service where money must become local cash or a bank deposit |
| After a payout | With the recipient, in the account or wallet they chose |

At no step does the money sit in an account that UJIRA controls. For a split payout, each leg goes straight to a destination the recipient controls.

## Why it matters

- **Less to trust.** If UJIRA never holds your money, UJIRA cannot lose it or spend it.
- **Safe for agents.** An agent's key can only ask a mandate for payouts that its rules already allow. A leaked key cannot drain the mandate beyond those rules, and the principal can pause or revoke the mandate at once.
- **Checkable.** Every payout settles on a public network and leaves a receipt with a transaction hash, so anyone can verify it.

## What protects the money

- **Mandate rules.** The total budget, per-payment cap, per-person daily cap, allowed recipients or countries, approval threshold and expiry are enforced by the mandate contract itself. See [Mandates](mandates.md).
- **Approvals.** Payouts above the threshold wait for a named person, and every decision goes into an audit log.
- **Pause and revoke.** The principal can stop a mandate at any time.
- **No double payments.** Every request that moves money carries an idempotency key, so a retried request is never paid twice. See [Payouts and split payouts](payouts.md#idempotency).
- **Separation between customers.** Every record belongs to exactly one principal, and one principal can never read or pay from another principal's data or mandates.
- **Audited before mainnet.** The mandate contracts will not run with real money (on **mainnet**, the live network) until they have passed an independent external security audit.

## Example

A platform's agent is compromised, and an attacker gets its key.

- The mandate has a per-payment cap of $200.00, a per-person daily cap of $400.00, and only allows 50 named recipients.
- The attacker tries to pay $10,000.00 to their own wallet. The mandate refuses: the attacker's wallet is not an allowed recipient, and the amount breaks the cap.
- The platform pauses the mandate. No payout can run until it resumes, so the platform can investigate first, or revoke the mandate if it no longer trusts it.

The attacker could never move the money anywhere the rules did not already allow.

## Troubleshooting

**Does UJIRA ever hold funds "in transit"?** No. Money moves from the mandate toward the recipient's destination, never into an account UJIRA controls.

**How do I report a security issue?** A security contact and disclosure policy are not published yet. They will be added to these docs.

**Where are the audit reports?** There are none yet, because the contracts have not reached audit.
