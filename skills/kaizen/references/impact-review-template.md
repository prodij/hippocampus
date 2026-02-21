# Impact Review Template

After completing a kaizen cycle, run a before/after review to quantify the improvement.
This makes the moat visible and compounds motivation for future cycles.

## How to Run

After Step 6 (COMPOUND), measure and document:

### 0. Goal Validation — Did We Solve What We Set Out To Solve?

Before measuring anything, go back to the original trigger and ask:

1. **Restate the original problem** — what were we actually trying to fix?
2. **List each sub-goal** — break it into specific, testable claims
3. **Verdict per sub-goal** — ✅ solved, 🟡 partially, 🔴 not solved

```markdown
### Goal Validation
**Original problem**: [restate in one sentence]

| Sub-goal | Status | Evidence |
|---|---|---|
| [goal 1] | ✅/🟡/🔴 | [how you know] |
| [goal 2] | ✅/🟡/🔴 | [how you know] |
```

If any sub-goal is 🟡 or 🔴, document what's still needed and add it to the queue.
Don't close the kaizen cycle until the original intention is addressed — either solved
or consciously deferred with a reason.

**This prevents scope drift** — building cool stuff that doesn't actually solve the
problem that triggered the cycle.

### 1. Pick Metrics That Matter

Choose 3-7 metrics relevant to the improvement. Common ones:

| Category | Metrics |
|---|---|
| **Efficiency** | Tokens/turn, bytes injected, time per task, manual steps eliminated |
| **Quality** | Error rate, information relevance, stale data ratio |
| **Resilience** | Attack surface, recovery time, data durability |
| **Observability** | What was invisible before? What's now measurable? |
| **Compounding** | How does this connect to / amplify other improvements? |

### 2. Before vs After Table

```markdown
| Metric | Before | After | Δ |
|---|---|---|---|
| [metric 1] | [old value] | [new value] | [change] |
| [metric 2] | [old value] | [new value] | [change] |
```

Quantify where possible. "Better" isn't a measurement. "-81%" is.

### 3. Practical Impact Statement

Answer in 2-3 sentences: What does this mean for daily operation? Not the technical
details — the actual felt difference. Example:

> "Every turn costs ~1,800 fewer tokens on workspace injection. Over a 50-turn session,
> that's ~90,000 tokens freed for actual work. Context quality is higher because only
> active, relevant facts are loaded."

### 4. Compound Effect

How does this improvement make future improvements easier or better? This is what
turns individual fixes into a moat. Example:

> "Token savings → longer sessions → more complex work per session → fewer session
> restarts → less context loss → better continuity."

### 5. Append to Kaizen Log

Add the review to `memory/kaizen-log.md` under the cycle entry:

```markdown
### Impact Review
| Metric | Before | After | Δ |
|---|---|---|---|
| ... | ... | ... | ... |

**Practical impact**: [2-3 sentences]
**Compounds with**: [what it amplifies]
```

## Why This Matters

Without measurement, improvements are anecdotal. With measurement:
- You can prove the moat is deepening
- You can prioritize future kaizen cycles by expected impact
- You build a track record that justifies investing time in systems over patches
- Future-you can look back and see accumulated advantage
