# HeatStack - the smarter DCA bot

**Dollar-cost averaging, but smarter.** HeatStack buys your chosen crypto every month - **more when prices are cheap, less when they are hot** - on your own Kraken account. Set it up once, then let it work.

> **Free beta:** the first **100 new Kraken users** who sign up through our link get HeatStack free during the beta. See the [website](https://duplexsteel.github.io/HeatStack/) for how to join.

---

## What it does

- **Monthly buying, weighted by "heat".** Heat = today's price vs. its 200-day average. Very cheap → up to 3× your normal buy. Overheated → skip. Plain DCA buys the same amount whatever the price.
- **Your coins, your weights.** Any coin Kraken trades against USD, e.g. `BTC:40, ETH:25, SOL:10` - or use the default mix.
- **Buys only by default.** Profit-taking near all-time highs is opt-in - leave it off and set your own sell orders if you like.
- **Buy now** button for an extra top-up with the same rules.
- **A full cockpit:** portfolio with average cost and profit per coin, trade history, manual orders, news.

## Built-in safety

- Starts in **dry run** - shows what it would do, places nothing, until you switch it on.
- **Refuses API keys that can withdraw.** Your key can trade, never move money off Kraken.
- Your key stays **on your own machine** - it is never sent to us.
- Caps per order and per day, and no buying within 10% of a coin's all-time high.

## Where it runs

| | |
|---|---|
| **Windows PC** | Installer - runs while the app is open |
| **Linux server** | One-command install, runs 24/7 (a few euros a month at Hetzner, DigitalOcean, Oracle, ...) |
| **Home Assistant** | Add-on for 24/7 on a Raspberry Pi, with dashboard tiles *(advanced)* |
| **Phone** | Open the app from your phone with a PIN (same Wi-Fi or Tailscale). Android app planned. |

One membership covers all of them.

## Get started

1. Download the latest version from **[Releases](../../releases/latest)**.
2. Follow the **[setup guide](https://duplexsteel.github.io/HeatStack/setup.html)** - about 15 minutes from zero to a running bot (in dry run).
3. Going live needs a licence: free for beta testers, membership after launch.

## About this repository

This repository hosts the **website, setup guide and release downloads** for HeatStack. HeatStack itself is **commercial software** (not open source): free during the beta for the first 100 new Kraken users, paid membership after launch. Please don't redistribute the downloads.

Found a bug or have a question? Open an [issue](../../issues).

---

**Your money, your risk.** HeatStack is software, not an investment service. It is not financial advice and does not promise returns. Crypto prices can fall a lot and you can lose money. Past results and backtests do not predict future results. You are responsible for your settings, your account and your taxes.
