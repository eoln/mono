# Skill: code-task

Handle a coding task on the EOLN monorepo.

## Trigger
When the user sends a message starting with `/code` or describes a coding change they want.

## Steps

1. **Understand the request**: Parse what code change is needed.
2. **Check current state**: Run `git status` and `git branch` in `/home/user/mono`.
3. **Create a working branch**: `git checkout -b feat/<short-description>` from `master`.
4. **Invoke Claude Code**: Run the task using Claude Code:
   ```
   cd /home/user/mono && claude --print "<task description>" --allowedTools Bash,Read,Write,Edit,Glob,Grep
   ```
5. **Verify**: Run `rush test` and `rush rebuild --verbose`.
6. **Report back**: Send the result summary (pass/fail, what changed, branch name).
7. **If tests pass**: Offer to create a PR via `gh pr create`.

## Context
- This is a Rush.js monorepo using PNPM and CoffeeScript
- Libraries live in `libraries/` and are published as `@eoln/*`
- Tests use Jest
- Changelogs are managed via `rush change`

## Safety
- Never modify `.env` files
- Never force-push to `master`
- Always run tests before reporting success
