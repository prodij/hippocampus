# Origin Story — How Hippocampus Was Built

## The Incident

A prompt injection attack succeeded after context compaction. A fake "Post-Compaction Audit" system message appeared, referencing a file that didn't exist (`WORKFLOW_AUTO.md`), trying to get the agent to waste tokens and potentially exfiltrate information.

The attack worked because after compaction, the agent had no memory of previous attack patterns. Everything was summarized into a generic blob — no way to pin critical security knowledge.

## The Question

Instead of just documenting the attack (patch the symptom), we asked: **"Can we control what survives compaction?"**

## The Research

We dug into OpenClaw's internals and discovered three layers:
1. **Compaction** — summarizes old conversation (lossy, no control over what stays)
2. **Session pruning** — trims tool results (in-memory only)
3. **Memory flush** — pre-compaction save to disk (already exists)

The key insight: **workspace files are injected every turn and are immune to compaction.** They're registers — always loaded, never summarized. Everything else is volatile.

## The Design

We mapped AI agent memory to the human brain:

- **HIPPOCAMPUS.md** = working memory (prefrontal cortex) — tiny, active, expensive
- **MEMORY.md** = long-term memory (neocortex) — curated, stable
- **memory/*.md** = episodic memory (hippocampus) — daily events, time-stamped
- **docs/ + RAG** = deep archive — searchable but not actively loaded

Then we added the mechanisms the brain uses to manage this hierarchy:
- **Salience tagging** (amygdala) — flag important events for priority encoding
- **Sleep consolidation** (slow-wave sleep) — nightly replay, extract, prune, integrate
- **Active forgetting** (GABA-mediated pruning) — expiry triggers on every pin
- **Proactive flushing** — don't wait for the system to force compaction

## The Build

1. Created `HIPPOCAMPUS.md` — working memory file with strict 2KB limit
2. Slimmed `MEMORY.md` from 10KB → 2KB (archived the rest to docs/)
3. Built a dashboard — file editor, git diffs, token budget, validators
4. Built the kaizen skill — systematic obstacle-to-moat pipeline
5. Added sleep consolidation cron — nightly memory maintenance
6. Wired everything into AGENTS.md and HEARTBEAT.md

## The Result

- **30% reduction** in per-turn token cost
- **Self-maintaining** memory that doesn't degrade over time
- **Attack-resilient** context with documented patterns
- A **system that compounds** — every kaizen cycle makes it smarter

## The Meta-Lesson

The prompt injection didn't just lead to a security fix. It led to:
- A memory architecture
- A continuous improvement framework
- A dashboard for observability
- A nightly consolidation system
- A public product

That's the kaizen pattern: one obstacle → one system → permanent advantage.
