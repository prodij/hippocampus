# Curation Protocol — What Stays, What Moves, What Dies

## Salience Tagging

When writing to daily notes, tag entries with importance:
- 🔴 HIGH — security incidents, errors that cost time/trust, breakthroughs, novel events, J frustrated/excited
- 🟡 MED — project progress, decisions, new info that connects to existing knowledge
- ⚪ LOW — routine ops, status checks, minor changes

Format: `## HH:MM — Description [🔴 HIGH]`

During sleep consolidation: 🔴 always promoted. 🟡 kept if relevant. ⚪ compressed or pruned.

## The Test

For every piece of information, ask: **"If I lose this next turn, what breaks?"**

- Something breaks → **HIPPOCAMPUS.md** (working memory, loaded every turn)
- Nothing breaks now, but I'll need it this week → **MEMORY.md** (long-term)
- Historical record → **memory/YYYY-MM-DD.md** (daily notes)
- Reference I might search for someday → **docs/ or RAG** (archive)
- Nothing → **delete it**

## HIPPOCAMPUS.md — What Earns Space (<2KB)

### IN (active working memory)
- Current focus (1-2 items I'm literally working on)
- Active blockers (what's stopping progress right now)
- Session decisions that affect next steps
- Facts needed in the next 1-3 exchanges
- Corrections to my defaults ("J said use X not Y for this task")
- Expiration conditions for each pin

### OUT (demote immediately)
- Resolved blockers → daily notes as "resolved"
- Completed focus items → daily notes
- Pins whose trigger condition is met → daily notes or MEMORY.md
- Context older than 48h that hasn't been referenced → MEMORY.md or delete
- Background facts not relevant to current focus → MEMORY.md

### Format
Every pin MUST have an expiration trigger:
```markdown
- [fact] → EXPIRES when [condition]
```
No open-ended pins. If you can't name when it expires, it belongs in MEMORY.md.

## MEMORY.md — What Earns Space (<4KB)

### IN (curated long-term)
- About J (identity, preferences, communication style)
- Team roster (names + roles, not config details)
- Top 5 lessons (hard-won, frequently relevant)
- Active project summaries (2-3 sentences each, max 4 projects)
- Cost/security policies
- Patterns that keep coming up

### OUT (archive to docs/ or RAG)
- Infrastructure details (ports, IPs, configs) → docs/infrastructure.md
- Completed project notes → docs/project-archive.md
- Agent roster details (models, containers) → docs/agent-roster.md
- One-time troubleshooting steps → docs/ or RAG
- Historical decisions that no longer affect current work → daily notes

### Review cadence
- Weekly during heartbeat: scan for stale entries
- After project completion: archive project summary
- After major infrastructure change: update docs/infrastructure.md

## Proactive Flush Protocol

### When to flush (don't wait for compaction)

Check context health via `session_status`. Flush at these thresholds:

| Context % | Action |
|-----------|--------|
| <50% | Normal operation. No action needed. |
| 50-60% | **Awareness.** Scan HIPPOCAMPUS.md for stale pins. |
| 60-75% | **Proactive flush.** Write current state to daily notes. Remove resolved pins from HIPPOCAMPUS.md. Summarize conversation highlights. |
| 75-85% | **Aggressive flush.** Write everything important to files. Strip HIPPOCAMPUS.md to absolute essentials. Consider `/compact` with focus instructions. |
| 85%+ | **Emergency.** Immediate write to daily notes. `/compact Keep only: [current focus from HIPPOCAMPUS.md]` |

### How to flush
1. Update HIPPOCAMPUS.md (remove stale, update focus)
2. Write session narrative to `memory/YYYY-MM-DD.md`
3. Archive anything from MEMORY.md that's become reference material
4. If >75%, request `/compact` with: "Keep: [HIPPOCAMPUS focus items]. Discard: [resolved threads]"

## The Flow

```
New information arrives
        │
        ▼
  Is it needed right now? ──yes──→ HIPPOCAMPUS.md (with expiry trigger)
        │ no
        ▼
  Will I need it this week? ──yes──→ MEMORY.md (if under 4KB budget)
        │ no                              │ over budget
        ▼                                 ▼
  Is it worth searching later? ──yes──→ docs/*.md or RAG index
        │ no
        ▼
    Daily notes (if timestamped record)
    or DELETE (if truly disposable)
```

## Staleness Detection (heartbeat task)

Every heartbeat, run this check on HIPPOCAMPUS.md:

1. Read each pin's expiration trigger
2. Has the trigger been met? → Remove, log to daily notes
3. Has pin been untouched >48h? → Demote to MEMORY.md or delete
4. Is Focus still accurate? → Update if work shifted
5. Is Queue still relevant? → Prune completed/superseded items
6. Is file >2KB? → Something needs to move out

Log changes: "Hippocampus maintenance: removed N stale pins, updated focus to X"
