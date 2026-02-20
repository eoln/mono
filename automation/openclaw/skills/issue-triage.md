# Skill: issue-triage

Triage and manage GitHub issues from Telegram.

## Trigger
When the user sends `/issue` or asks about issues, bugs, or tasks.

## Commands

### `/issue list` — List open issues
Fetch open issues from eoln/mono and display a summary.

### `/issue <number>` — Show issue details
Fetch a specific issue and display title, body, labels, assignees.

### `/issue create <title>` — Create a new issue
Create a GitHub issue with the provided title. Ask for body/labels if not provided.

### `/issue assign <number> claude` — Assign to Claude Code
Label the issue with `claude-code` and trigger the code-task skill.

### `/issue close <number>` — Close an issue
Close the specified issue with a comment.

## Implementation
Use the GitHub tool to interact with the `eoln/mono` repository.
Use `gh issue list`, `gh issue view`, `gh issue create`, etc.

## Response Format
Keep Telegram responses concise. Use numbered lists for issue lists.
Include issue URLs for easy tap-through on mobile.
