# How UJIRA counts days

> **Status:** UJIRA is in development. The way days are counted is settled and is described here. Dashboard details are not final.

## What it is

UJIRA counts days in two ways, on purpose:

| What you are looking at | The day it uses |
| --- | --- |
| Reports: period totals, date filters and exports | Your **reporting time zone**, a setting on your account |
| A recipient's per-person daily cap | The **UTC day**, which runs 00:00 to 23:59 UTC |

**UTC** (Coordinated Universal Time) is the world's reference clock, the one every other time zone is measured against. A **UTC day** is a calendar day on that clock.

Reports use your reporting time zone so that "yesterday" means your yesterday. The per-person daily cap cannot do that. It is enforced by the mandate contract on Stellar, and a contract has no time zone setting: it only knows UTC. See [Mandates](mandates.md).

So the two counts agree for most of the day and disagree near your local midnight.

## Why it matters

If your reporting time zone is **ahead of UTC**, the first hours of your day belong to the previous UTC day. Lagos is one hour ahead of UTC, so for a Lagos principal:

- Each recipient's daily cap resets at **01:00** Lagos time, not at midnight.
- A payout between 00:00 and 00:59 Lagos counts against the **previous** day's cap, while your reports count it in the new day.

If your reporting time zone is **behind UTC**, the mismatch falls in the evening instead: the last hours of your day already belong to the next UTC day.

The size of the gap is your zone's offset from UTC, so where summer time is observed the reset moves by an hour with it. Lagos does not observe summer time, so its reset stays at 01:00 all year.

Both counts are correct. Neither is a bug, and neither can be changed to match the other.

## Worked example

A principal in Lagos sets its reporting time zone to Lagos. One recipient has a per-person daily cap of $400.00. These are the payouts:

| Payout | Lagos time | UTC time | Counts in reports as | Counts against the cap for |
| --- | --- | --- | --- | --- |
| A | 23:30 Monday 12 January | 22:30 Monday 12 January | Monday 12 | Monday 12 |
| B | 00:30 Tuesday 13 January | 23:30 Monday 12 January | Tuesday 13 | Monday 12 |
| C | 02:00 Tuesday 13 January | 01:00 Tuesday 13 January | Tuesday 13 | Tuesday 13 |

Payout A is the quiet case: late in the Lagos evening, both counts say Monday. Payouts B and C are the ones that surprise people.

**What the principal sees.** Suppose payout A did not happen, and payouts B and C are each $400.00.

- The Overview for **Tuesday 13 in Lagos** shows $800.00 paid to that recipient, which is twice their daily cap.
- The mandate refused nothing. Payout B filled the cap for the UTC day Monday 12, and payout C filled the cap for the UTC day Tuesday 13. Two UTC days, two caps, both respected.

**The other way round.** Suppose instead that the recipient was already paid $400.00 at 15:00 Monday in Lagos, and a $100.00 payout is requested at 00:30 on Tuesday.

- The Overview for Tuesday shows nothing paid to that recipient yet, so it looks like there is room.
- The mandate refuses the payout, because on the UTC day Monday 12 the recipient has already had $400.00.
- The same $100.00 payout goes through from **01:00** Lagos time, when the UTC day turns over.

If you read only one thing on this page: near your local midnight, check the recipient's cap against the UTC day, not against your own day.

## What the reporting time zone does not change

Changing the setting only changes which day figures are grouped into. It does not:

- change any payout, or move any money;
- change any cap, or when a cap resets, since caps always use the UTC day;
- change any receipt, including the time a receipt shows;
- re-run or undo any decision the mandate already made.

It applies to past figures too, so a total you exported last week may be grouped differently after a change. The payouts behind it are the same payouts.

## Where each figure says which day it uses

So you never have to guess:

- Period totals, date filters and exports name the reporting time zone they used.
- Figures about a recipient's daily cap are labelled as a UTC day.

## Changing the setting

> **Planned.** The dashboard setting is not built yet, so this section describes the intention and not current behaviour. How days are counted, above, is settled and does not depend on it.

The plan is that the principal changes its reporting time zone in the dashboard, that only people the principal authorises can change it, that changing it needs a second identity confirmation at that moment, and that each change is recorded with who made it and when, so a total that looks different from last month's can be traced to the change.

Which roles may change it, and what each step is called, are decided by the dashboard work rather than here. They will be documented when that ships.

## Troubleshooting

**A payout was refused, but the recipient's total for today looks well under their cap.** Check the payout's UTC time. If it was within an hour or so of your local midnight, it probably counted against the previous UTC day, which may have been full. See the worked example above.

**A recipient's total for one day is above their daily cap.** The day in your report covers parts of two UTC days, and the cap applies to each UTC day separately. Nothing was overpaid.

**Two reports of the same period do not match.** Check whether the reporting time zone changed between them, and whether one report came from a system using UTC.

**Can the cap follow my reporting time zone instead?** No. The cap is enforced on Stellar by the mandate contract, which has no time zone.
