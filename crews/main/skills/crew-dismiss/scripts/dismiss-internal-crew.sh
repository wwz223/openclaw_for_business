#!/bin/bash
# dismiss-internal-crew.sh - 下线内部 Crew（workspace 归档）
# 用法: bash ./skills/crew-dismiss/scripts/dismiss-internal-crew.sh <agent-id>
set -e

OPENCLAW_HOME="$HOME/.openclaw"

# 复用 HRBP 的 remove-agent 脚本
HRBP_SKILLS_BASE="$OPENCLAW_HOME/workspace-hrbp/skills"
REMOVE_AGENT_SCRIPT="$HRBP_SKILLS_BASE/hrbp-remove/scripts/remove-agent.sh"

if [ ! -f "$REMOVE_AGENT_SCRIPT" ]; then
  echo "❌ remove-agent.sh not found at: $REMOVE_AGENT_SCRIPT"
  echo "   Ensure HRBP workspace is installed (run setup-crew.sh)."
  exit 1
fi

[ -z "$1" ] && {
  echo "Usage: $0 <agent-id>"
  exit 1
}

AGENT_ID="$1"

# 附加的内部 crew 保护检查（remove-agent.sh 也会检查，双重保险）
if [ "$AGENT_ID" = "main" ] || [ "$AGENT_ID" = "hrbp" ] || [ "$AGENT_ID" = "it-engineer" ]; then
  echo "❌ '$AGENT_ID' is a protected built-in agent and cannot be dismissed."
  exit 1
fi

exec bash "$REMOVE_AGENT_SCRIPT" "$AGENT_ID"
