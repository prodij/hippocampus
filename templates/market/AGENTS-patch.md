# AGENTS.md Patch — Market Agent Memory Architecture

Add these sections to the trading agent's AGENTS.md.

---

## Memory Architecture (Market-Specific)

```
HIPPOCAMPUS.md  → Today's trading state only. Levels, positions, regime. <2KB.
MEMORY.md       → Patterns, win rates, data quirks, calendar effects. <4KB.
memory/*.md     → Daily trade logs with P&L. Tagged by salience.
docs/*.md       → Archived analysis, backtest results, historical patterns.
```

### Trading Working Memory (HIPPOCAMPUS.md)
- **Flush 4x daily**: pre-market, post-open, midday, post-close
- Nearly **100% turnover daily** — yesterday's levels are stale
- Contains: regime assessment, key levels, live positions, active playbook, calendar
- **Every level/position has an explicit expiry** (most = EOD)

### Market Long-Term Memory (MEMORY.md)
- **Patterns, not data** — "GEX walls hold 70% in low vol" stays; "GEX wall at 5950" doesn't
- Win rates updated during sleep consolidation after trade reviews
- Data quirks (lag, gaps, limitations) so you don't get burned twice
- Calendar awareness (OPEX, FOMC, CPI timing)

### Salience Tagging for Trades
Tag daily note entries:
- 🔴 HIGH — regime flips, large losses, model failures, unusual flow, novel conditions
- 🟡 MED — trade entries/exits, playbook activations, notable flow
- ⚪ LOW — routine snapshots, data pulls, status checks

### Flush Schedule
| Time (ET) | Action |
|---|---|
| 8:30 AM | Load fresh GEX/vanna levels. Clear yesterday. Load calendar events. |
| 10:00 AM | Update regime assessment from opening action. Log positions. |
| 12:30 PM | Flush morning trades to daily notes. Compress HIPPOCAMPUS. |
| 4:20 PM | Full EOD flush. P&L to daily notes. Clear all intraday data. |
| 11:00 PM | Sleep consolidation. Pattern extraction. Win rate updates. |

---

## Kaizen — Continuous Improvement

When you encounter any of these, read `skills/kaizen/SKILL.md` and follow the protocol:
- Same trade mistake twice
- Data feed failure or stale data served
- Playbook underperforming its historical win rate
- Context overflow during market hours (critical — can't lose positions mid-day)
- "This setup keeps failing" friction
- User says "kaizen this"

Don't just skip the trade — build a system that prevents the class of error.
