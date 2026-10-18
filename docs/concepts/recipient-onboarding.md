# Recipient onboarding and the embed widget

> **Status:** UJIRA is in development. This page describes how onboarding and the embed widget are designed to work. The widget is not available yet, so there is no install snippet on this page.

## What it is

**Recipient onboarding** is how a person becomes payable. Before UJIRA can pay a recipient, it needs to know who they are and how they want to receive money.

Onboarding happens once per recipient:

1. **Invite.** The principal invites the recipient. The invite opens the onboarding widget.
2. **Verify identity.** The recipient verifies their identity once. This is often called **KYC** (know your customer): the identity checks that licensed payment services must run before paying someone.
3. **Pick a method.** The recipient chooses how to be paid: local currency into a bank account, to mobile money or as cash, or "USDC to your Stellar wallet", named plainly. The methods offered depend on the recipient's country. For bank, mobile money or cash, the recipient sees the anchor's fee and exchange rate before they choose. See [Who pays what](payouts.md#who-pays-what).

Split payouts are planned: recipients will be able to add a second method and set a split, for example "30% as USDC to my Stellar wallet, the rest to mobile money". See [Payouts and split payouts](payouts.md#split-payouts).

The **embed widget** is the ready-made screen that runs these steps inside your own product. You add it to your site with a script tag, and it appears as a **web component**: a standard HTML element that works in any web framework, or in none. You do not build onboarding yourself.

## Why it matters

- **You skip the hardest part.** Identity checks and payout details differ by country. The widget handles them, so you do not build and maintain onboarding for each country.
- **Recipients stay in your product.** The widget takes your brand: your colours and your look. It shows only a small "Payouts by UJIRA" line with the UJIRA mark in its footer.
- **The right methods appear automatically.** Onboarding knows which payout methods work in which country. It records the recipient's choice so UJIRA can route each payout correctly. The wallet option is named plainly, "USDC to your Stellar wallet", alongside bank, mobile money and cash. A recipient who picks a local-currency method sees only their own currency.

The widget is planned as a hosted widget that supports theming. Full white-label is also planned.

## Example

A bounty platform has a new winner in Accra.

1. The platform invites her. She gets a link that opens the widget inside the platform's own site, in the platform's colours.
2. She verifies her identity once.
3. She picks mobile money as her payout method.
4. From now on the platform can pay her prizes. Because she chose mobile money, she sees only her own currency.

## Troubleshooting

**A recipient cannot find their preferred method.** Methods depend on what is available in their country. The list of supported countries and methods is not published yet.

**A recipient failed identity verification.** They cannot be paid until verification succeeds. What they can do next will be documented with the widget.

**Where is the install snippet?** The widget's tag name, attributes and theming options are not final. They will be added here, with a tested example, when the widget is released.
