#!/bin/bash
# lib.sh - Shared helpers for HRBP lifecycle scripts
# Source this file: source "$(dirname "$0")/../../hrbp-common/scripts/lib.sh"

# Validate agent-id format: lowercase alphanumeric + hyphens, no leading/trailing hyphens, max 63 chars (DNS label).
validate_agent_id() {
  local id="$1"
  if ! printf '%s\n' "$id" | grep -Eq '^[a-z0-9]([a-z0-9-]{0,61}[a-z0-9])?$'; then
    echo "❌ Invalid agent-id: $id"
    echo "   Expected: lowercase letters, numbers, hyphens; no leading/trailing hyphens; max 63 chars"
    echo "   Example: customer-service-a"
    exit 1
  fi
}
