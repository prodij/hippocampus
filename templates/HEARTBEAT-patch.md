# HEARTBEAT.md Patch — Add This Section

Add this as the FIRST section in your HEARTBEAT.md:

---

## FIRST: Context + Memory Health
- Run `session_status`. Follow flush thresholds:
  - 50-60%: scan HIPPOCAMPUS.md for stale pins
  - 60-75%: proactive flush to daily notes, remove resolved pins
  - 75-85%: aggressive flush, strip HIPPOCAMPUS to essentials, consider `/compact`
  - 85%+: emergency write + `/compact` immediately
- Check HIPPOCAMPUS.md staleness: any pin >48h? any resolved triggers? file >2KB?
