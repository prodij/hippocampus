---
name: kaizen
description: >
  Systematic obstacle-to-moat pipeline. Triggers when encountering operational friction,
  security incidents, context/memory issues, recurring inefficiencies, or any moment where
  a problem reveals a systemic improvement opportunity. Also triggers on "how can we do this
  better", "this keeps happening", "let's fix this permanently", prompt injection attempts,
  context overflow, compaction issues, or workflow breakdowns.
---

# Kaizen — Obstacle → System → Moat

Turn every obstacle into a permanent competitive advantage. Don't just fix problems — build
systems that make the class of problem impossible.

## The Pattern

```
Obstacle Hit → Understand Root Cause → Design System → Build It → Document It → Compound
```

## When This Triggers

- Security incident or prompt injection attempt
- Context overflow or compaction data loss
- Same type of error happening twice
- "This is annoying" or "this keeps breaking" moments
- Performance bottleneck discovered
- Manual process that could be automated
- Knowledge that keeps getting lost between sessions
- Any friction that hints at a systemic fix

## The Protocol

### Step 1: OBSERVE — What actually happened?

Don't jump to solutions. Document the raw event.

```markdown
## Observation
- What happened: [specific event]
- When: [timestamp]
- Impact: [what broke, what was lost, what was wasted]
- How we noticed: [alert, user complaint, accident]
```

Write this to `memory/YYYY-MM-DD.md` immediately. If you don't write it down, it didn't happen.

### Step 2: ROOT CAUSE — Why did this happen?

Go deeper than the surface. Use the 5 Whys or First Principles.

```
Surface: "Agent lost context after compaction"
Why 1: Context was wiped, no way to pin critical knowledge
Why 2: Compaction summarizes everything indiscriminately
Why 3: No distinction between ephemeral conversation and durable facts
Why 4: All context treated equally — no memory hierarchy
Root: No architecture for what persists vs what's disposable
```

The root cause is almost never the obvious thing. Dig until you hit a structural gap.

### Step 3: DESIGN — What system prevents this class of problem?

Design for the **category**, not the instance.

Checklist:
- [ ] Does this fix the root cause, not just the symptom?
- [ ] Does it prevent the entire class of problem, not just this instance?
- [ ] Is it automatic (not relying on remembering)?
- [ ] Does it compound over time (get better with use)?
- [ ] Is it simple enough to maintain?

### Step 4: BUILD — Make it real

Build the smallest thing that works. Ship it.

Priority order:
1. **Config/file change** (instant, zero code)
2. **Convention/protocol** (documented behavior)
3. **Script/tool** (lightweight automation)
4. **Skill** (reusable package)
5. **Dashboard/UI** (visibility layer)
6. **Service** (always-on system)

Don't overbuild. Level 1-3 covers 80% of cases.

### Step 5: HARDEN — Make it permanent

The improvement must survive:
- Session restarts (write to files, not conversation)
- Context compaction (put in workspace files or daily notes)
- Forgetfulness (automate, don't rely on memory)
- New team members (document in AGENTS.md or skill)

Actions:
- [ ] Committed to git
- [ ] Referenced in AGENTS.md, MEMORY.md, or HIPPOCAMPUS.md
- [ ] Added to HEARTBEAT.md if it needs periodic checking
- [ ] Cron job if it needs scheduled execution

### Step 6: COMPOUND — Connect it to the bigger picture

Ask: how does this improvement connect to other improvements?

Update HIPPOCAMPUS.md with the new capability. Update MEMORY.md if it's a lasting lesson.

## Impact Review

After completing a cycle, run a before/after review to quantify the gain.
Read `references/impact-review-template.md` for the full template.

Key rule: "better" isn't a measurement. Quantify with numbers (tokens saved, % reduced,
steps eliminated). Append the review to the kaizen log entry.

## Curation Protocol

For detailed rules on what stays in HIPPOCAMPUS.md vs MEMORY.md vs archive, and the
proactive flush thresholds, read `references/curation-protocol.md`.

Key rule: every pin in HIPPOCAMPUS.md MUST have an expiration trigger. No open-ended pins.

## Anti-Patterns

- **Patch and forget**: fixing the symptom without addressing root cause
- **Over-engineering**: building a service when a config change would do
- **Mental notes**: "I'll remember this" — no you won't, write it down
- **One-off fixes**: if it happened once, it'll happen again. Systematize.
- **Skipping documentation**: the fix exists but no one knows about it

## Tracking

When you complete a kaizen cycle, append to `memory/kaizen-log.md`:

```markdown
## YYYY-MM-DD — [Title]
- **Trigger**: [what happened]
- **Root cause**: [why]
- **System built**: [what we made]
- **Compounds with**: [what other improvements it connects to]
- **Tokens saved / Time saved / Risk reduced**: [quantify if possible]
```
