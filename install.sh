#!/usr/bin/env bash
set -euo pipefail

# 🧠 Hippocampus Installer
# Brain-inspired memory management for OpenClaw agents

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
WORKSPACE="${OPENCLAW_WORKSPACE:-${HOME}/.openclaw/workspace}"
INSTALL_SKILL=true
INSTALL_CRON=true
INSTALL_DASHBOARD=true
SLEEP_TZ="America/Los_Angeles"
SLEEP_HOUR="23"
DASHBOARD_PORT="18999"
DELIVERY_CHANNEL=""
DELIVERY_TO=""

usage() {
  cat <<EOF
🧠 Hippocampus Installer

Usage: ./install.sh [options]

Options:
  --workspace <path>     Workspace path (default: ~/.openclaw/workspace)
  --skill-only           Only install the kaizen skill
  --no-cron              Skip sleep consolidation cron job
  --no-dashboard         Skip dashboard setup
  --tz <timezone>        Sleep cron timezone (default: America/Los_Angeles)
  --hour <0-23>          Sleep cron hour (default: 23)
  --port <port>          Dashboard port (default: 18999)
  --channel <channel>    Delivery channel for sleep results (discord/telegram/slack)
  --to <id>              Delivery target (channel/chat ID)
  -h, --help             Show this help
EOF
}

while [[ $# -gt 0 ]]; do
  case $1 in
    --workspace) WORKSPACE="$2"; shift 2 ;;
    --skill-only) INSTALL_CRON=false; INSTALL_DASHBOARD=false; shift ;;
    --no-cron) INSTALL_CRON=false; shift ;;
    --no-dashboard) INSTALL_DASHBOARD=false; shift ;;
    --tz) SLEEP_TZ="$2"; shift 2 ;;
    --hour) SLEEP_HOUR="$2"; shift 2 ;;
    --port) DASHBOARD_PORT="$2"; shift 2 ;;
    --channel) DELIVERY_CHANNEL="$2"; shift 2 ;;
    --to) DELIVERY_TO="$2"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown option: $1"; usage; exit 1 ;;
  esac
done

echo "🧠 Hippocampus Installer"
echo "   Workspace: $WORKSPACE"
echo ""

# Verify workspace exists
if [[ ! -d "$WORKSPACE" ]]; then
  echo "❌ Workspace not found: $WORKSPACE"
  echo "   Run 'openclaw setup' first or specify --workspace"
  exit 1
fi

# --- Step 1: Install kaizen skill ---
echo "📦 Installing kaizen skill..."
mkdir -p "$WORKSPACE/skills/kaizen/references"
cp "$SCRIPT_DIR/skills/kaizen/SKILL.md" "$WORKSPACE/skills/kaizen/SKILL.md"
cp "$SCRIPT_DIR/skills/kaizen/references/"*.md "$WORKSPACE/skills/kaizen/references/"
echo "   ✅ skills/kaizen/ installed"

# --- Step 2: Create HIPPOCAMPUS.md (if not exists) ---
if [[ ! -f "$WORKSPACE/HIPPOCAMPUS.md" ]]; then
  cp "$SCRIPT_DIR/templates/HIPPOCAMPUS.md" "$WORKSPACE/HIPPOCAMPUS.md"
  echo "   ✅ HIPPOCAMPUS.md created"
else
  echo "   ⏭️  HIPPOCAMPUS.md already exists (skipped)"
fi

# --- Step 3: Create memory directory ---
mkdir -p "$WORKSPACE/memory"

# --- Step 4: Patch AGENTS.md ---
if [[ -f "$WORKSPACE/AGENTS.md" ]]; then
  if ! grep -q "HIPPOCAMPUS.md" "$WORKSPACE/AGENTS.md"; then
    echo ""
    echo "📋 AGENTS.md needs the memory architecture section."
    echo "   Review and add the contents of templates/AGENTS-patch.md"
    echo "   to your AGENTS.md file."
    echo ""
    echo "   Quick append (review first!):"
    echo "   cat $SCRIPT_DIR/templates/AGENTS-patch.md >> $WORKSPACE/AGENTS.md"
    echo ""
  else
    echo "   ⏭️  AGENTS.md already has hippocampus references (skipped)"
  fi
else
  echo "   ⚠️  No AGENTS.md found. Create one or run 'openclaw setup'"
fi

# --- Step 5: Patch HEARTBEAT.md ---
if [[ -f "$WORKSPACE/HEARTBEAT.md" ]]; then
  if ! grep -q "curation-protocol" "$WORKSPACE/HEARTBEAT.md"; then
    echo ""
    echo "📋 HEARTBEAT.md needs flush threshold section."
    echo "   Review and add the contents of templates/HEARTBEAT-patch.md"
    echo ""
  else
    echo "   ⏭️  HEARTBEAT.md already has flush thresholds (skipped)"
  fi
fi

# --- Step 6: Sleep consolidation cron ---
if [[ "$INSTALL_CRON" == true ]]; then
  if command -v openclaw &>/dev/null; then
    echo "🌙 Setting up sleep consolidation cron..."
    
    # Check if already exists
    EXISTING=$(openclaw cron list --json 2>/dev/null | grep -c "sleep-consolidation" || true)
    if [[ "$EXISTING" -gt 0 ]]; then
      echo "   ⏭️  sleep-consolidation cron already exists (skipped)"
    else
      CRON_ARGS=(
        --name "sleep-consolidation"
        --description "Nightly memory consolidation — replay, extract, consolidate, prune, integrate"
        --cron "0 $SLEEP_HOUR * * *"
        --tz "$SLEEP_TZ"
        --session isolated
        --timeout-seconds 120
        --thinking low
        --message "You are running the nightly sleep consolidation cycle. Read skills/kaizen/references/sleep-consolidation.md and follow all 5 phases. Determine today's date, then read the daily notes, HIPPOCAMPUS.md, MEMORY.md, and memory/kaizen-log.md. Execute each phase: REPLAY, EXTRACT, CONSOLIDATE, PRUNE, INTEGRATE. Write the consolidation summary to today's daily notes. Keep changes conservative — when unsure whether to prune, keep."
      )
      
      if [[ -n "$DELIVERY_CHANNEL" && -n "$DELIVERY_TO" ]]; then
        CRON_ARGS+=(--announce --channel "$DELIVERY_CHANNEL" --to "$DELIVERY_TO")
      fi
      
      openclaw cron add "${CRON_ARGS[@]}" > /dev/null 2>&1 && \
        echo "   ✅ Sleep consolidation cron added (${SLEEP_HOUR}:00 ${SLEEP_TZ})" || \
        echo "   ⚠️  Failed to add cron (is the gateway running?)"
    fi
  else
    echo "   ⚠️  openclaw CLI not found — skipping cron setup"
    echo "   Install OpenClaw and run this again, or add the cron manually"
  fi
fi

# --- Step 7: Dashboard ---
if [[ "$INSTALL_DASHBOARD" == true ]]; then
  echo "📊 Installing dashboard..."
  mkdir -p "$WORKSPACE/tools/hippocampus-dashboard"
  cp "$SCRIPT_DIR/dashboard/server.js" "$WORKSPACE/tools/hippocampus-dashboard/server.js"
  cp "$SCRIPT_DIR/dashboard/index.html" "$WORKSPACE/tools/hippocampus-dashboard/index.html"
  
  # Update port if custom
  if [[ "$DASHBOARD_PORT" != "18999" ]]; then
    sed -i.bak "s/const PORT = 18999/const PORT = $DASHBOARD_PORT/" \
      "$WORKSPACE/tools/hippocampus-dashboard/server.js"
    rm -f "$WORKSPACE/tools/hippocampus-dashboard/server.js.bak"
  fi
  
  echo "   ✅ Dashboard installed"
  echo "   Run: node $WORKSPACE/tools/hippocampus-dashboard/server.js"
  echo "   Open: http://127.0.0.1:$DASHBOARD_PORT"
fi

# --- Step 8: Create kaizen log ---
if [[ ! -f "$WORKSPACE/memory/kaizen-log.md" ]]; then
  cp "$SCRIPT_DIR/examples/kaizen-log-example.md" "$WORKSPACE/memory/kaizen-log.md"
  echo "   ✅ memory/kaizen-log.md created"
fi

echo ""
echo "🧠 Hippocampus installed!"
echo ""
echo "Next steps:"
echo "  1. Review and customize HIPPOCAMPUS.md"
echo "  2. Slim your MEMORY.md to <4KB (archive details to docs/)"
echo "  3. Add memory architecture section to AGENTS.md (see templates/AGENTS-patch.md)"
echo "  4. Restart your OpenClaw gateway to pick up the new skill"
echo ""
echo "The sleep consolidation cron will run nightly. Your agent will start"
echo "managing its own memory — just like your brain does."
