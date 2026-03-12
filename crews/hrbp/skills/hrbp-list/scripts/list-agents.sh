#!/bin/bash
# list-agents.sh - 列出所有注册的 Agent 及其状态
# 用法: bash ./skills/hrbp-list/scripts/list-agents.sh
# 数据来源: ~/.openclaw/TEAM_DIRECTORY.md（由 setup-crew.sh / sync-team-directory.sh 生成）
set -e

OPENCLAW_HOME="${OPENCLAW_HOME:-$HOME/.openclaw}"
TEAM_DIRECTORY_PATH="$OPENCLAW_HOME/TEAM_DIRECTORY.md"

if [ ! -f "$TEAM_DIRECTORY_PATH" ]; then
  echo "❌ Team directory not found: $TEAM_DIRECTORY_PATH"
  echo "   Run ./scripts/setup-crew.sh to regenerate it."
  exit 1
fi

cat "$TEAM_DIRECTORY_PATH"
