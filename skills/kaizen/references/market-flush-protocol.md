# Market Flush Protocol

Market-specific memory management with clock-driven flush cycles aligned to
the trading day rhythm.

## Why Markets Are Different

General agents flush when context fills up. Market agents flush on the **clock**
because market data has **hard expiry** — yesterday's GEX levels are noise, not signal.

Working memory turnover is nearly 100% daily. Long-term memory is patterns, not data.

## Flush Cycles

### Pre-Market Load (8:30 AM ET)
**Goal**: Start the day with a clean slate and fresh context.

Actions:
1. Clear HIPPOCAMPUS.md of all yesterday's levels, positions, regime assessment
2. Fetch fresh GEX/vanna levels from S3
3. Check economic calendar (CPI, FOMC, earnings)
4. Load any overnight flow signals from ClickHouse
5. Write regime hypothesis: "Expecting [pinned/trending/volatile] based on [evidence]"

### Post-Open Assessment (10:00 AM ET)
**Goal**: Update regime based on first 30 min of real data.

Actions:
1. Update regime assessment (was hypothesis correct?)
2. Log any positions entered at open
3. Note any surprising flow or price action
4. Update key levels if they've shifted

### Midday Flush (12:30 PM ET)
**Goal**: Consolidate morning, prepare for afternoon.

Actions:
1. Write morning trade log to `memory/YYYY-MM-DD.md` with salience tags
2. Compress HIPPOCAMPUS — remove completed/irrelevant morning context
3. Check live positions: stops, targets, any adjustment needed
4. Assess: has the regime changed since open?
5. Check context % — if >60%, flush aggressively (can't afford overflow during power hour)

### EOD Flush (4:20 PM ET)
**Goal**: Full day review, everything to disk, clean slate.

Actions:
1. Close out HIPPOCAMPUS — write all remaining positions + P&L to daily notes
2. Tag every trade: 🔴 (lesson), 🟡 (routine), ⚪ (minor)
3. Write EOD summary:
   ```markdown
   ## EOD Summary — YYYY-MM-DD [🟡 MED]
   - Regime: [what actually happened]
   - P&L: [net]
   - Trades: [count] ([W]W-[L]L)
   - Key observation: [most important thing learned]
   - Playbook used: [pack name] — [worked/failed] because [reason]
   ```
4. Clear HIPPOCAMPUS.md to template state (empty positions, no levels)
5. Sector rotation snapshot (existing cron handles this)

### Sleep Consolidation (11:00 PM ET)
**Goal**: Extract lasting patterns from today's ephemeral data.

Extends standard sleep protocol with market-specific phases:
1. **Trade Review**: For each trade, ask: was the playbook selection correct? was the entry timing good? was the stop appropriate?
2. **Win Rate Update**: Update MEMORY.md playbook performance table
3. **Pattern Extraction**: Any new regime pattern? Any data quirk discovered?
4. **Failure Analysis**: Any 🔴 HIGH trades → root cause → kaizen if repeated
5. **Calendar Prep**: Any major events tomorrow? Note in HIPPOCAMPUS pre-load.

## Salience Tagging for Markets

### 🔴 HIGH — Always promoted, always reviewed
- Regime flips (pinned → trending, low vol → high vol)
- Losses > 1% of capital
- Playbook failures (expected setup, wrong outcome)
- Data feed outages during market hours
- Novel market conditions (first time seeing this pattern)
- GEX wall breaks (expected hold, broke through)

### 🟡 MED — Kept if connects to pattern
- Trade entries and exits (routine, expected outcome)
- Playbook activations
- Notable flow (>$1M premium, unusual direction)
- Regime confirming events

### ⚪ LOW — Compressed or pruned
- Routine data pulls and snapshots
- Status checks
- Minor level adjustments
- Position monitoring (no change)

## Context Overflow During Market Hours

This is **critical** — losing context mid-session during market hours means losing
track of live positions. Prevention:

1. Never let context exceed 60% during market hours
2. At 50%, start flushing — don't wait for 60%
3. Keep HIPPOCAMPUS.md under 1KB during trading (not 2KB)
4. If approaching 70%: emergency flush + `/compact Keep only: live positions and current levels`
5. After hours: normal thresholds apply

The worst outcome isn't a bad trade — it's forgetting you have a position open.
