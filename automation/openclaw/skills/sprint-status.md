# Skill: sprint-status

Report sprint status from ZenHub and sync to Notion.

## Trigger
When the user sends `/sprint` or asks about sprint progress.

## Commands

### `/sprint` — Current sprint summary
Fetch the active ZenHub sprint and report:
- Total issues in sprint
- Issues by pipeline (New, In Progress, Review, Done)
- Velocity vs estimate
- Blocked items

### `/sprint board` — Show the board
Display a compact text representation of the ZenHub board.

### `/sprint sync` — Force sync to Notion
Trigger the n8n ZenHub→Notion sync workflow via webhook.

## Implementation
- Use the ZenHub API: `https://api.zenhub.com/p2/workspaces/{workspace_id}/repositories/{repo_id}/board`
- Requires `ZENHUB_API_TOKEN` and `ZENHUB_WORKSPACE_ID` environment variables
- For Notion sync, POST to the n8n webhook URL stored in `N8N_WEBHOOK_URL`

## Response Format
Use a compact board view:
```
Sprint: Feb 17-28
━━━━━━━━━━━━━━━━
📋 New (3)        → #42, #45, #48
🔨 In Progress (2) → #41, #44
👀 Review (1)     → #40
✅ Done (4)       → #36, #37, #38, #39
━━━━━━━━━━━━━━━━
Velocity: 21/34 pts
```
