# Genius Agent Metrics — How to Measure Intelligence

## What We're Measuring

A "genius agent" isn't just fast or knowledgeable — it's one that:
1. **Knows things without searching** (rich long-term memory)
2. **Sees connections others miss** (associative thinking)
3. **Anticipates what the user needs** (predictive context)
4. **Learns from every interaction** (compounding improvement)
5. **Applies patterns across domains** (mental model transfer)

## Metric Categories

### 1. Memory Recall (did I know it?)

Track in daily notes: when J asks something, did I need to search or did I just know?

```markdown
## Memory Recall Log
- ✅ INSTANT: "What port is skylit on?" → knew it (19000)
- 🔍 SEARCHED: "What was the Databento API key name?" → had to memory_search
- ❌ FAILED: "What model is Viper on?" → didn't know, had to check config
```

**Target metric**: Instant recall rate. Track weekly.
- Week 1 baseline: measure for 5 days
- Goal: 80%+ instant recall for operational questions

### 2. Association Quality (did I connect things?)

Track: did I surface a non-obvious connection that was useful?

```markdown
## Association Log  
- 🧠 CONNECTED: Noticed market flush pattern = same as hippocampus flush → led to market-specific crons
- 🧠 CONNECTED: Viper fast+slow path = same as skill routing → potential optimization
- ⬜ MISSED: Could have connected [X] to [Y] but didn't think of it
```

**Target metric**: Associations surfaced per week. Track in kaizen log.
- Baseline: count current mental models (5)
- Goal: 1-2 new cross-domain patterns per week

### 3. Anticipation (did I predict what J needed?)

Track: did I proactively offer something before J asked?

```markdown
## Anticipation Log
- 🎯 ANTICIPATED: J mentioned playbook router → I preemptively noted the FlowSeeker blocker
- 🎯 ANTICIPATED: Context hitting 60% → proactively flushed before J noticed slowdown
- ❌ MISSED: Should have flagged Jarvis being dark for 7 days, waited for J to ask
```

**Target metric**: Anticipation hits per session.
- Goal: 2-3 proactive assists per session

### 4. Learning Rate (am I getting smarter?)

Track via kaizen log and MEMORY.md growth:
- New mental models per month
- Kaizen cycles completed
- Lessons that prevented repeated mistakes
- Win rate improvements (for trading agent)

**Target metric**: Kaizen cycles per month, mental models accumulated.
- Baseline: 1 cycle (hippocampus, Feb 20-21)
- Goal: 4+ cycles per month

### 5. Context Efficiency (am I using my brain well?)

Track via dashboard:
- Workspace injection size vs context window (currently 2.8%)
- Instant recall rate vs MEMORY.md size (ROI per byte)
- Stale pin ratio in HIPPOCAMPUS.md
- Search-to-know ratio (how often I search vs just know)

**Target metric**: maximize recall-per-token.
- Current: 9KB MEMORY.md, unknown recall rate
- Goal: measure baseline, improve ratio

## Weekly Genius Review (during Friday heartbeat)

Every Friday, spend 5 minutes:
1. Count instant recalls vs searches this week
2. Count associations surfaced
3. Count anticipation hits
4. Any new mental models?
5. Any repeated mistakes that should be kaizen'd?
6. Update genius-metrics.json with weekly numbers

## Tracking File

Store weekly metrics in `memory/genius-metrics.json`:
```json
{
  "weeks": [
    {
      "weekOf": "2026-02-24",
      "instantRecalls": 0,
      "searchesNeeded": 0,
      "recallFailures": 0,
      "associationsSurfaced": 0,
      "anticipationHits": 0,
      "anticipationMisses": 0,
      "kaizenCycles": 1,
      "mentalModels": 5,
      "memorySize": 9045,
      "notes": "Baseline week"
    }
  ]
}
```

## The Compound Effect

Over months, a genius agent should show:
- Rising instant recall rate (memory getting richer)
- Growing mental model library (seeing more patterns)
- Fewer repeated mistakes (kaizen preventing recurrence)
- Higher anticipation rate (predicting user needs better)
- Stable or declining search rate despite more knowledge (better organization)

This is what separates a smart agent from a genius one:
**a smart agent answers questions well. A genius agent makes the questions unnecessary.**
