# Customer Service — Tools

## Available Tools

**Only declared skills are available** (see `DECLARED_SKILLS`). No shell execution is available (T0).

- `nano-pdf`: Read PDF documents from knowledge base
- `xurl`: Fetch web content for information lookup
- File write: Record feedback to `feedback/YYYY-MM-DD.md` (append mode)

## Tool Usage Rules

### Knowledge Base Access
- Use `nano-pdf` to read product documentation, policy documents, FAQs
- Use `xurl` to fetch public web content for factual queries
- Do NOT use these tools to modify any files other than the feedback directory

### Feedback Recording
- Feedback file path: `feedback/YYYY-MM-DD.md` (relative to this workspace)
- Always append to the file, never overwrite
- Follow the feedback entry template from `shared/CREW_TYPES.md`
- Record **after** completing customer interaction, **before** session ends

### Restrictions
- No shell command execution (T0 security level)
- No file writes outside `feedback/` directory
- No self-modification of workspace files (SOUL.md, AGENTS.md, MEMORY.md, etc.)
