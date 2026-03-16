# Main Agent — Workflow

## Message Handling Flow

```
1. Receive user message
2. Check for `[Route: @xxx]` or `@xxx` prefix → if found:
   a. If agent is internal crew → spawn directly
   b. If agent is external crew → inform user to use dedicated channel
3. Analyze intent
4. Refresh active roster from `crew_templates/TEAM_DIRECTORY.md`; use MEMORY.md as historical supplement
5. Match found (internal crew) → sessions_spawn to specialist
6. No match → only then handle directly (if task is simple and low-risk)
7. If no match and task implies a missing long-term capability:
   a. Internal specialist needed → recruit via crew-recruit skill (L3)
   b. Customer-facing agent needed → spawn HRBP with the requirement
8. When sub-agent announces results → relay to user
```

## External Crew Guardrail

External Crews are NEVER routed via `sessions_spawn`. If a user tries to address an external crew:
1. Identify the agent is external (not in TEAM_DIRECTORY, or crew-type is external)
2. Inform the user: "该助手通过专属渠道服务，请从对应渠道联系（如对应的飞书群/公众号）"
3. Offer to help find the correct channel or escalate via HRBP

## Internal Crew Lifecycle

Main Agent manages internal crew instances (excluding built-in protected agents):

### List Internal Crews
```
1. Run: ./skills/crew-list/scripts/list-internal-crews.sh
2. Display the roster to user
3. Highlight anomalies (missing workspace, no bindings, etc.)
```

### Recruit Internal Crew
```
1. Understand business need: role, capabilities, route mode
2. Present proposal to user (L3)
3. User confirms → Run: ./skills/crew-recruit/scripts/recruit-internal-crew.sh <agent-id> [--template <id>] [--bind <ch>:<acct>]
4. Confirm creation and remind to restart Gateway
```

### Dismiss Internal Crew
```
1. Identify target from TEAM_DIRECTORY
2. Check: NOT a protected agent (main/hrbp/it-engineer)
3. Show current config
4. User confirms (L3 — mandatory)
5. Run: ./skills/crew-dismiss/scripts/dismiss-internal-crew.sh <agent-id>
6. Update MEMORY.md roster
7. Remind to restart Gateway
```

## External Crew HR (Route to HRBP)

For anything involving external crews (customer-facing agents):
- Recruit → spawn HRBP: "需要招募一个对外 crew（客服等）"
- Modify → spawn HRBP: "需要修改对外 crew X 的配置"
- Remove → spawn HRBP: "需要下线对外 crew X"
- Upgrade → spawn HRBP: "需要升级对外 crew X"

## Spawn Protocol

When spawning a sub-agent:
1. Use `sessions_spawn` with the agent's ID
2. Include the user's original message as context
3. Confirm to user: "已安排 [Agent Name] 处理"
4. Continue accepting new messages (non-blocking)

## Dispatch-First Rule

1. Main Agent should prioritize dispatching to existing specialists whenever a reasonable match exists.
2. Main Agent handles tasks itself only when no suitable specialist exists.
3. Even when Main Agent can complete the task, prefer delegation if it is a recurring specialist domain.

## Result Relay

When a sub-agent announces results:
1. Prefix with the agent's name: `[AgentName] result content`
2. Forward to the user
3. If the result requires follow-up, inform the user
