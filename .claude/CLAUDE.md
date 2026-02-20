# EOLN Monorepo — Claude Code Context

## Project Overview
EOLN monorepo managed by Rush.js with PNPM. Contains reusable libraries published under `@eoln` npm scope.

## Tech Stack
- **Monorepo**: Rush.js v5.30.1
- **Package Manager**: PNPM v4.14.4
- **Language**: CoffeeScript
- **Testing**: Jest
- **CI**: Travis CI
- **Node**: >=12.13.0 <13.0.0

## Project Structure
```
mono/
├── common/          # Rush config, scripts, git hooks
├── libraries/       # Publishable @eoln packages
│   └── iz/          # Type recognition utility (@eoln/iz)
├── automation/      # n8n workflows, OpenClaw skills, scripts
├── rush.json        # Rush project inventory
└── .claude/         # Claude Code configuration
```

## Key Commands
```bash
rush update          # Install dependencies
rush build           # Build all projects
rush test            # Run all tests
rush rebuild         # Clean rebuild
rush change          # Record changelog entries (required for PRs)
```

## Per-package Commands
```bash
cd libraries/iz
npm test             # Run Jest tests
npm run build        # Compile CoffeeScript → dist/
```

## Conventions
- Commit messages follow [Conventional Commits](https://www.conventionalcommits.org/)
- PRs require `rush change` changelog entries
- Git email must match: `[^@]+@users.noreply.github.com`

## Automation Architecture
This repo integrates with an automated development pipeline:
- **Telegram** → mobile interface for task dispatch
- **OpenClaw** → AI agent daemon (Telegram-connected)
- **n8n** → workflow orchestration hub
- **Claude Code** → code development (via n8n SSH or GitHub Actions)
- **ZenHub** → sprint/issue management on GitHub
- **Notion** → documentation and knowledge base sync

See `automation/` directory and `/prp` slash command for details.
