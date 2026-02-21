# Architecture

## Context Window Budget

Every turn, OpenClaw injects workspace files into the model's context. This is your
"always-on" memory budget:

| File | Target Size | Tokens (est) | Purpose |
|---|---|---|---|
| AGENTS.md | 4-8KB | 1000-2000 | Operating instructions |
| SOUL.md | 2-4KB | 500-1000 | Persona and tone |
| HIPPOCAMPUS.md | <2KB | <500 | Working memory |
| MEMORY.md | <4KB | <1000 | Long-term memory |
| TOOLS.md | 1KB | 250 | Tool notes |
| HEARTBEAT.md | 0.5KB | 125 | Periodic check list |
| IDENTITY.md | 0.2KB | 50 | Name and vibe |
| USER.md | 0.2KB | 50 | User info |
| **Total target** | **<20KB** | **<5000** | |

The default OpenClaw `bootstrapMaxChars` is 20,000. Stay well under this.

## File Lifecycle

```
New information
    │
    ▼
Needed right now? ──yes──→ HIPPOCAMPUS.md (with expiry trigger)
    │ no
    ▼
Needed this week? ──yes──→ MEMORY.md (if under 4KB budget)
    │ no                        │ over budget
    ▼                           ▼
Worth searching? ──yes──→ docs/*.md or RAG
    │ no
    ▼
Daily notes (timestamped) or DELETE
```

## Sleep Consolidation Pipeline

```
11 PM ─→ Isolated Session
              │
              ├─ REPLAY: Read daily notes + HIPPOCAMPUS + MEMORY
              │
              ├─ EXTRACT: Find patterns, connections, novel events
              │
              ├─ CONSOLIDATE: Promote insights, archive completed work
              │
              ├─ PRUNE: Remove resolved pins, compress old notes
              │
              ├─ INTEGRATE: Update schemas, link lessons
              │
              └─ COMMIT: Git commit + push, announce results
```

## Compaction Resilience

```
                    Immune to compaction
                    (injected every turn)
                    ┌─────────────────┐
                    │ AGENTS.md       │
                    │ SOUL.md         │
                    │ HIPPOCAMPUS.md  │  ← This is the key insight.
                    │ MEMORY.md       │     These survive no matter what.
                    │ TOOLS.md        │
                    │ etc.            │
                    └─────────────────┘

                    Volatile (compacted/lost)
                    ┌─────────────────┐
                    │ Conversation    │
                    │ Tool results    │
                    │ Intermediate    │
                    │ reasoning       │
                    └─────────────────┘

                    Durable (on disk)
                    ┌─────────────────┐
                    │ memory/*.md     │
                    │ docs/*.md       │
                    │ RAG index       │
                    └─────────────────┘
```

Anything that matters goes in a file. Everything else is disposable.
