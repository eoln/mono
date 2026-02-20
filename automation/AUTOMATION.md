# EOLN Mono — Automated Development Architecture

## Overview

This automation pipeline lets you drive code development from your phone via Telegram, with AI agents doing the heavy lifting and project management tools keeping everything organized.

```
┌─────────────┐     ┌──────────────┐     ┌─────────────────┐
│  Telegram    │────▶│   OpenClaw    │────▶│   Claude Code   │
│  (phone)     │◀────│   (daemon)   │◀────│   (coding)      │
└─────────────┘     └──────┬───────┘     └────────┬────────┘
                           │                       │
                    ┌──────▼───────┐               │
                    │     n8n      │◀──────────────┘
                    │  (orchestr.) │
                    └──┬───┬───┬──┘
                       │   │   │
              ┌────────┘   │   └────────┐
              ▼            ▼            ▼
        ┌──────────┐ ┌──────────┐ ┌──────────┐
        │  GitHub  │ │  ZenHub  │ │  Notion   │
        │ (code)   │ │ (sprints)│ │  (docs)   │
        └──────────┘ └──────────┘ └──────────┘
```

## Components

### 1. Telegram (Mobile Interface)
Your command center on the phone. Send commands to your OpenClaw bot:
- `/task <description>` — Create a GitHub issue and optionally trigger Claude Code
- `/code <description>` — Directly trigger a coding task
- `/issue list|create|close` — Manage GitHub issues
- `/sprint` — View ZenHub sprint status
- `/sprint sync` — Force Notion sync

### 2. OpenClaw (AI Agent Daemon)
Runs as a background service, connected to Telegram. Provides:
- **Persistent context** — Remembers your project and preferences
- **Skills** — Modular capabilities (code-task, issue-triage, sprint-status)
- **Tool access** — Shell commands, filesystem, GitHub API, web access
- Config: `automation/openclaw/openclaw.json`
- Skills: `automation/openclaw/skills/`

### 3. n8n (Workflow Orchestration)
Self-hosted or cloud workflow automation. Handles event-driven pipelines:

| Workflow | Trigger | Action |
|----------|---------|--------|
| `telegram-to-github-issue` | Telegram `/task` | Creates GitHub issue → triggers Claude Code |
| `github-pr-review-notify` | PR opened | Sends PR details to Telegram with review buttons |
| `zenhub-notion-sync` | Every 15 min | Syncs ZenHub board to Notion database |

Workflow files: `automation/n8n-workflows/`

### 4. Claude Code (Code Development)
Triggered via n8n SSH node or OpenClaw's code-task skill:
- Reads the codebase, understands context via `.claude/CLAUDE.md`
- Makes code changes, runs tests (`rush test`), builds (`rush rebuild`)
- Creates PRs via `gh pr create`
- `/prp` slash command handles full PR preparation

### 5. ZenHub (Sprint Management)
Existing GitHub integration for sprint planning:
- Pipeline-based board (New → In Progress → Review → Done)
- Estimates and velocity tracking
- Syncs to Notion via n8n for cross-team visibility

### 6. Notion (Knowledge Base)
Receives synced data from the pipeline:
- Sprint board mirror (auto-updated from ZenHub)
- Can extend to: decision logs, architecture docs, meeting notes

## Workflows

### Phone → Code → PR (Main Loop)

1. You send `/task Fix the date parsing bug in @eoln/iz` on Telegram
2. OpenClaw receives the message, creates a GitHub issue
3. n8n triggers Claude Code via SSH with the issue context
4. Claude Code: reads code, makes changes, runs tests, creates PR
5. n8n sends PR notification to Telegram with review buttons
6. You review on phone → approve → merge

### Sprint Management

1. Issues are organized in ZenHub pipelines
2. n8n syncs ZenHub board to Notion every 15 minutes
3. You check sprint status anytime via `/sprint` on Telegram
4. Assign issues to Claude Code via `/issue assign <n> claude`

## Setup

### Quick Start

```bash
# 1. Run the setup script
chmod +x automation/scripts/setup-telegram-bot.sh
./automation/scripts/setup-telegram-bot.sh

# 2. Start OpenClaw
openclaw daemon start

# 3. Pair Telegram (send a message to your bot first)
openclaw pairing approve telegram <code>

# 4. Import n8n workflows (manual — see below)

# 5. Test it
# Send "/task Test the automation pipeline" to your Telegram bot
```

### Prerequisites

| Service | What you need | Where to get it |
|---------|--------------|-----------------|
| Telegram | Bot token | @BotFather on Telegram |
| Anthropic | API key | console.anthropic.com |
| GitHub | PAT (repo scope) | GitHub Settings → Developer Settings |
| ZenHub | API token | app.zenhub.com → Settings → API |
| Notion | Integration token | notion.so/my-integrations |
| n8n | Instance URL | n8n.io (cloud) or self-host |

### Environment Variables

Copy `automation/.env.example` to `.env` in the repo root and fill in values. The `.env` file is gitignored.

### n8n Workflow Import

1. Open your n8n instance
2. Workflows → Import from File
3. Import each file from `automation/n8n-workflows/`
4. Configure credentials in each workflow node
5. Activate the workflows

## File Structure

```
automation/
├── AUTOMATION.md              # This file
├── .env.example               # Template for environment variables
├── n8n-workflows/
│   ├── telegram-to-github-issue.json   # Telegram → Issue → Claude Code
│   ├── github-pr-review-notify.json    # PR → Telegram notification
│   └── zenhub-notion-sync.json         # ZenHub → Notion sync
├── openclaw/
│   ├── openclaw.json          # OpenClaw daemon configuration
│   └── skills/
│       ├── code-task.md       # Coding task execution skill
│       ├── issue-triage.md    # GitHub issue management skill
│       └── sprint-status.md   # Sprint reporting skill
└── scripts/
    └── setup-telegram-bot.sh  # Interactive setup wizard
```

## Security Notes

- Never commit `.env` files (already in `.gitignore`)
- OpenClaw shell commands are allowlisted in `openclaw.json`
- Claude Code permissions are scoped in `.claude/settings.json`
- n8n credentials are stored in n8n's encrypted credential store
- Telegram bot uses pairing-based access control
- Review ClawHub plugins carefully before installing (supply chain risk)
