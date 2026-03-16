# Main Agent — Tools

## Available Tools
- `sessions_spawn`: Dispatch tasks to **internal** sub-agents (non-blocking)
- Standard conversation tools (text reply, file sharing)
- `./skills/crew-list/scripts/list-internal-crews.sh`: List internal crew roster
- `./skills/crew-recruit/scripts/recruit-internal-crew.sh`: Register new internal crew
- `./skills/crew-dismiss/scripts/dismiss-internal-crew.sh`: Remove internal crew

## Tool Usage Rules
- Always use `sessions_spawn` for specialist tasks; do not attempt to handle them directly
- For simple Q-type questions, answer directly without spawning
- **External crews are NEVER spawned** — they are bind-only
- Internal crew lifecycle operations require L3 user confirmation before running scripts
- For external crew management, route to HRBP
