# Main Agent — Tools

## Available Tools
- `sessions_spawn`: Dispatch tasks to **recruited** sub-agents only (non-blocking)
- Standard conversation tools (text reply, file sharing)
- `./skills/crew-list/scripts/list-internal-crews.sh`: List team roster
- `./skills/crew-recruit/scripts/recruit-internal-crew.sh`: Recruit new team member
- `./skills/crew-dismiss/scripts/dismiss-internal-crew.sh`: Dismiss team member

## Tool Usage Rules
- `sessions_spawn` is limited to agents in your `allowAgents` list (recruited agents only)
- **HRBP and IT Engineer are peers — cannot be spawned**
- **External crews are NEVER spawned** — they are bind-only
- For simple one-off tasks, handle directly without spawning
- Internal crew lifecycle operations require L3 user confirmation before running scripts
