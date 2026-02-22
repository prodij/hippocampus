# Sleep Consolidation Protocol

Nightly process that mimics the brain's sleep-based memory consolidation.
Runs as a cron job at 11 PM PST in an isolated session.

## Phase 1: REPLAY
Read today's raw memories and current state:
- `memory/YYYY-MM-DD.md` (today)
- `memory/YYYY-MM-DD.md` (yesterday, if not already consolidated)
- `HIPPOCAMPUS.md` (current working memory)
- `memory/kaizen-log.md` (any new cycles)

## Phase 2: EXTRACT
Analyze for patterns and insights:
- What happened today that's **novel**?
- Any **repeated patterns** across recent days? (same error twice = kaizen trigger)
- Any **connections** between seemingly unrelated events?
- What was tagged 🔴 HIGH? What made it important?
- Any **corrections** to existing beliefs/assumptions?

## Phase 3: CONSOLIDATE
Move memories to their proper tier:
- **Lasting insights** → promote to MEMORY.md (if under 4KB budget)
- **Reusable patterns** → promote to AGENTS.md rules or skill references
- **Completed work** → archive to docs/*.md
- **Index dense docs** → RAG (if rag skill available)
- **Strengthen** entries that were accessed/referenced today

## Phase 4: PRUNE
Active forgetting:
- Remove **resolved** HIPPOCAMPUS pins (expiry trigger met)
- Flag MEMORY.md entries **not referenced in 7+ days** for review
- **Compress** verbose daily notes older than 3 days into summaries
- **Delete** truly disposable context (routine ops, resolved one-offs)
- Check file sizes: HIPPOCAMPUS <2KB, MEMORY <4KB

## Phase 5: INTEGRATE
Connect new knowledge to existing schemas:
- Update **project summaries** with today's progress
- Link today's lessons to **existing lessons** (strengthen or merge)
- Update **kaizen log** if a cycle progressed or completed
- Update **HIPPOCAMPUS.md** focus/queue based on what's actually active

## Phase 6: ASSOCIATE (genius mode)
Creative cross-domain linking — the Default Mode Network equivalent:
- Read MEMORY.md Mental Models section
- Ask: "Does anything from today map to an existing mental model?"
- Ask: "Did two unrelated events today share an underlying pattern?"
- Ask: "Can a solution from one domain apply to a problem in another?"
- If a new cross-domain pattern emerges → add to Mental Models
- Update HIPPOCAMPUS.md Cross-Thread Insights with any new connections
- This is where breakthroughs come from: connecting trading to neuroscience to software

## Output
Write a brief consolidation log to daily notes:
```markdown
## 🌙 Sleep Consolidation — YYYY-MM-DD
- Promoted: [what moved to MEMORY.md]
- Archived: [what moved to docs/]
- Pruned: [what was removed]
- Patterns: [any new patterns detected]
- Connections: [any cross-links discovered]
```

## Salience Levels (for tagging)
- 🔴 HIGH — security incidents, errors that cost time/trust, breakthroughs, J frustrated/excited, first-time events
- 🟡 MED — project progress, decisions, new information that connects to existing knowledge
- ⚪ LOW — routine ops, status checks, minor config changes

During consolidation: 🔴 always reviewed and promoted. 🟡 kept if connects to schema. ⚪ compressed or pruned.
