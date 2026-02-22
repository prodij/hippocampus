# MEMORY.md — Market Long-Term Memory
> Max 4KB. Data-specific details archived to docs/. This is PATTERNS, not data.

## Regime Patterns
- When dealer gamma is short + VIX > 20: trends extend, don't fade
- GEX walls hold ~70% in low-vol regimes, break more in high-vol
- Vanna flows dominate T-5 to T-1 before OPEX
- First 15 min flow direction predicts session ~60%
- 0DTE gamma intensifies pinning after 2 PM ET

## Playbook Performance
<!-- Update after each trade review during sleep consolidation -->
| Pack | Win Rate | Best Regime | Worst Regime | Notes |
|---|---|---|---|---|
| SPXW_PINNING | —% | Low vol, near OPEX | VIX > 25 | |
| SPXW_TREND_VOL | —% | VIX > 25, trending | Chop/range | |
| ETF_OPTIONS_GAMMA | —% | Sector divergence | Correlated selloff | |
| MAG7_OPTIONS_FLOW | —% | Earnings season | Low flow | |
| EQUITY_SHARES_CORE | —% | Confirmed trend | Regime transition | |

## Data Source Quirks
- S3 GEX snapshots: ~30sec lag at open, sub-second otherwise
- ClickHouse flow data: gaps on early-close days (half days)
- FlowSeeker: doesn't distinguish opening vs closing trades
- Sector rotation divergences >2 std dev revert within 3 sessions

## Key Relationships
- SPY gamma ↔ QQQ gamma: usually correlated, divergence = signal
- VIX term structure: contango = calm, backwardation = fear
- Flow size threshold for significance: >$1M premium

## Calendar Patterns
- Monthly OPEX (3rd Fri): vanna/charm dominate T-5 to T-1
- Quarterly OPEX (Mar/Jun/Sep/Dec): amplified effect
- FOMC: vol crush after, expansion before — avoid new positions T-1
- CPI/NFP: morning gap risk, widen stops pre-release

## Lessons Learned
<!-- Promoted from daily notes during sleep consolidation -->
