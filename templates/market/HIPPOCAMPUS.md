# HIPPOCAMPUS.md — Trading Working Memory
> Last updated: YYYY-MM-DD HH:MM ET | Max 2KB
> Flush: pre-market (8:30), post-open (10:00), midday (12:30), post-close (4:20)
> Rule: most pins expire at EOD. No stale levels.

## Active Regime
- SPX: [trending/pinned/volatile]
- VIX: [level] [rising/falling/stable]
- GEX flip: [level]
- Dominant flow: [calls/puts] [aggressive/passive]
- Dealer gamma: [long/short] → [mean-revert/trend]

## Key Levels Today
- GEX wall: [level] → EXPIRES EOD
- Vanna exposure: [positive/negative] → EXPIRES EOD
- Support: [level] | Resistance: [level] → EXPIRES EOD
- Significant flow: [ticker, level, size, direction] → EXPIRES EOD

## Live Positions
- (none)
<!-- Format:
- [SPXW M/DD STRIKE C/P] → entry [price] at [time], target [X], stop [Y]
  → EXPIRES when closed or at expiry
-->

## Active Playbook
- Pack: (none active)
<!-- Format:
- Pack: SPXW_PINNING
- Setup: [condition]
- Entry trigger: [specific signal]
  → EXPIRES EOD or when trade closes
-->

## Calendar
- [Upcoming events: FOMC, CPI, OPEX, earnings]
  → EXPIRES after event

## Blockers
- (none)
