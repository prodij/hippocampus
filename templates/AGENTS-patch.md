# AGENTS.md Patch — Add These Sections

Add the following sections to your AGENTS.md file. Place them where appropriate
for your existing structure.

---

## Memory Architecture

You wake up fresh each session. These files are your continuity:

```
HIPPOCAMPUS.md  → Working memory (active focus, pins, queue) — <2KB, updated often
MEMORY.md       → Long-term memory (identity, lessons, active projects) — <4KB, curated
memory/*.md     → Daily episodic logs (raw notes per day)
docs/*.md       → Archived reference (infrastructure, old projects) — searchable via RAG
```

### 🧠 HIPPOCAMPUS.md - Working Memory
- **Loaded every turn** — this is what you're actively thinking about
- **Max 2KB** — if it's bigger, move things to MEMORY.md or daily notes
- Contains: current Focus (1-2 items), Pins (must-survive-compaction facts), Blockers, Queue (max 3)
- **Update it** whenever focus changes or a pin resolves
- Stale pins (>24h) should be moved or removed

### 📦 MEMORY.md - Long-Term Memory
- **Max 4KB** — overflow goes to `docs/` files (RAG-searchable, not auto-loaded)
- Contains: user info, team roster, top lessons, active project summaries
- Infrastructure details archived to `docs/infrastructure.md`
- Project history archived to `docs/project-archive.md`

### 🏷️ Salience Tagging (when writing daily notes)
Tag entries: `## HH:MM — Description [🔴 HIGH]`
- 🔴 HIGH — security, errors, breakthroughs, novel events
- 🟡 MED — project progress, decisions, new connections
- ⚪ LOW — routine ops, status checks, minor changes

### 🌙 Sleep Consolidation
Nightly cron runs in isolated session. Replays daily notes, extracts patterns,
promotes insights to MEMORY.md, prunes stale entries, integrates new knowledge.
Protocol: `skills/kaizen/references/sleep-consolidation.md`

### 📝 Write It Down - No "Mental Notes"!
If you want to remember something, WRITE IT TO A FILE. "Mental notes" don't survive
session restarts. Files do.

---

## Kaizen — Continuous Improvement

When you encounter any of these, read `skills/kaizen/SKILL.md` and follow the protocol:
- Same type of error happening twice
- Security incident or prompt injection attempt
- Context overflow or compaction data loss
- Manual process that could be automated
- Knowledge that keeps getting lost between sessions
- "This is annoying" or "this keeps breaking" friction
- User says "kaizen this", "let's improve this", or "fix this permanently"

Don't just patch the symptom — build a system that prevents the class of problem.
