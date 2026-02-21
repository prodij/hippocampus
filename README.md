# 🧠 Hippocampus

**Brain-inspired memory management for AI agents.**

Your AI agent forgets everything every session. Hippocampus fixes that — the way your brain does.

```
Working Memory → Long-Term Memory → Daily Logs → Deep Archive
    (2KB)           (4KB)          (per day)      (RAG)
```

With **nightly sleep consolidation** that replays, extracts patterns, prunes, and strengthens — just like your brain does during sleep.

## Results

| Metric | Before | After |
|---|---|---|
| Token waste per turn | ~6,160 tokens | ~4,318 tokens | **-30%** |
| Memory management | Manual, degrades over time | Self-maintaining via sleep cycle |
| Context control | None (compaction decides) | Full (you decide what's pinned) |
| Observability | None | Dashboard with budget, git diffs, validators |

## How It Works

Hippocampus models AI agent memory after the human brain:

| Brain System | Hippocampus Equivalent | Behavior |
|---|---|---|
| **Prefrontal Cortex** (working memory) | `HIPPOCAMPUS.md` | 2KB max, loaded every turn, actively managed |
| **Hippocampus** (temporary storage) | `memory/*.md` daily notes | Raw episodic logs, tagged by salience |
| **Neocortex** (long-term memory) | `MEMORY.md` + `docs/` | Curated facts, max 4KB, archived when full |
| **Amygdala** (emotional tagging) | Salience tags 🔴🟡⚪ | Priority encoding for important events |
| **Sleep consolidation** | Nightly cron job | Replay → Extract → Consolidate → Prune → Integrate |
| **Active forgetting** | Expiry triggers on pins | Every pin has a condition for removal |

### The Memory Hierarchy

```
┌─────────────────────────────────────────────────────┐
│                   CONTEXT WINDOW                     │
│                                                      │
│  ┌──────────────────────────────────┐               │
│  │        HIPPOCAMPUS.md            │  ← Working     │
│  │  Current focus, pinned facts     │    memory       │
│  │  Every pin has an expiry trigger │    (<2KB)       │
│  └──────────────────────────────────┘               │
│                                                      │
│  ┌──────────────────────────────────┐               │
│  │          MEMORY.md               │  ← Long-term   │
│  │  Identity, lessons, projects     │    memory       │
│  │  Curated, max 4KB               │    (<4KB)       │
│  └──────────────────────────────────┘               │
│                                                      │
│  ┌──────────────────────────────────┐               │
│  │     Conversation (volatile)      │  ← Compacted   │
│  │     Tool results (pruned)        │    when full    │
│  └──────────────────────────────────┘               │
└─────────────────────────────────────────────────────┘
         │ flush              │ archive
         ▼                    ▼
  ┌──────────────┐    ┌──────────────┐
  │ memory/*.md  │    │   docs/ +    │
  │ (daily logs) │    │   RAG index  │
  │ tagged 🔴🟡⚪ │    │              │
  └──────────────┘    └──────────────┘
```

### Proactive Context Flushing

Don't wait for auto-compaction at 95%. Flush early:

| Context % | Action |
|-----------|--------|
| <50% | Normal operation |
| 50-60% | Scan for stale pins |
| 60-75% | Flush to daily notes, remove resolved pins |
| 75-85% | Aggressive flush, strip to essentials |
| 85%+ | Emergency write + `/compact` |

### Sleep Consolidation (Nightly Cron)

Every night at 11 PM, an isolated session runs 5 phases:

1. **REPLAY** — Read today's daily notes and current state
2. **EXTRACT** — Find patterns, connections, novel events
3. **CONSOLIDATE** — Promote insights to MEMORY.md, archive completed work
4. **PRUNE** — Remove resolved pins, compress old notes, active forgetting
5. **INTEGRATE** — Connect new knowledge to existing schemas

Results are announced to your configured channel.

## Bonus: Kaizen Skill

Hippocampus includes a **continuous improvement skill** that turns operational friction into permanent advantages:

```
Obstacle → Observe → Root Cause → Design → Build → Harden → Compound → Impact Review
```

Triggers automatically on: recurring errors, security incidents, context issues, workflow breakdowns, or when you say "kaizen this."

Every cycle is logged with quantified before/after metrics — a running record of your agent getting smarter.

## Quick Start

### One-Command Install

```bash
curl -fsSL https://raw.githubusercontent.com/prodij/hippocampus/main/install.sh | bash
```

Or clone and run locally:

```bash
git clone https://github.com/prodij/hippocampus.git
cd hippocampus
./install.sh
```

### Manual Install

```bash
# Copy the kaizen skill
cp -r skills/kaizen ~/.openclaw/workspace/skills/

# Copy the working memory template
cp templates/HIPPOCAMPUS.md ~/.openclaw/workspace/

# Apply AGENTS.md patches (add memory architecture section)
# See templates/AGENTS-patch.md for what to add

# Start the dashboard (optional)
node dashboard/server.js
```

### Options

```bash
./install.sh                    # Full install
./install.sh --skill-only       # Just the kaizen skill
./install.sh --no-cron          # Skip sleep consolidation cron
./install.sh --no-dashboard     # Skip dashboard
./install.sh --workspace /path  # Custom workspace path
```

## Dashboard

A local web UI for managing your agent's memory:

- **File browser** — all workspace .md files with sizes
- **Editor** — edit files with live token count, Cmd+S to save
- **Git history** — diffs for any file
- **Token budget** — visual bar showing context injection cost
- **Validators** — warnings for oversized files, stale pins, budget overruns

```bash
node dashboard/server.js
# Open http://127.0.0.1:18999
```

## Configuration

### File Size Limits

Edit the limits in `dashboard/server.js` or set in your workflow:

| File | Default Limit | Why |
|---|---|---|
| `HIPPOCAMPUS.md` | 2,048 bytes | Working memory should be tiny |
| `MEMORY.md` | 4,096 bytes | Long-term memory should be curated |
| Total bootstrap | 30,000 bytes | All workspace files combined |

### Sleep Consolidation

The installer creates a cron job. Customize timing:

```bash
openclaw cron edit <id> --cron "0 23 * * *" --tz "America/New_York"
```

### Salience Tags

When writing daily notes, tag entries:

```markdown
## 14:30 — Deployed new auth system [🔴 HIGH]
## 15:00 — Updated README [⚪ LOW]
## 16:00 — Found connection between caching and latency [🟡 MED]
```

- 🔴 HIGH — security, errors, breakthroughs, novel events
- 🟡 MED — progress, decisions, new connections
- ⚪ LOW — routine ops, minor changes

## How It Was Built

This system emerged from a real incident: a prompt injection attack succeeded after context compaction because the agent had no control over what persisted. Instead of just patching that one issue, we built a system that prevents the entire class of problem.

Read the [full story](docs/origin-story.md) for the step-by-step journey from obstacle to product.

## Requirements

- [OpenClaw](https://github.com/openclaw/openclaw) (any recent version)
- Git (for dashboard history features)
- Node.js (for dashboard server)

## License

MIT

## Contributing

PRs welcome. The best contributions come from real friction — if you hit a memory management problem that Hippocampus doesn't handle, that's a kaizen cycle waiting to happen.
