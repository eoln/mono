#!/usr/bin/env bash
# setup-telegram-bot.sh — Bootstrap Telegram bot + n8n + OpenClaw integration
#
# Prerequisites:
#   - Telegram bot token from @BotFather
#   - n8n instance (cloud or self-hosted)
#   - Anthropic API key (for Claude via OpenClaw)
#   - GitHub personal access token
#   - ZenHub API token (optional)
#   - Notion integration token (optional)
#
# Usage:
#   chmod +x automation/scripts/setup-telegram-bot.sh
#   ./automation/scripts/setup-telegram-bot.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
ENV_FILE="$REPO_ROOT/.env"

echo "=== EOLN Mono — Automation Setup ==="
echo ""

# --- Collect credentials ---

if [ -f "$ENV_FILE" ]; then
  echo "Found existing .env file. Loading..."
  # shellcheck disable=SC1090
  source "$ENV_FILE"
else
  echo "No .env file found. Let's create one."
fi

prompt_var() {
  local var_name="$1"
  local prompt_text="$2"
  local current_val="${!var_name:-}"

  if [ -n "$current_val" ]; then
    echo "  $var_name is already set."
  else
    read -rp "  $prompt_text: " val
    echo "$var_name=$val" >> "$ENV_FILE"
    export "$var_name=$val"
  fi
}

echo ""
echo "--- Required Credentials ---"
prompt_var "TELEGRAM_BOT_TOKEN" "Telegram bot token (from @BotFather)"
prompt_var "ANTHROPIC_API_KEY" "Anthropic API key"
prompt_var "GITHUB_TOKEN" "GitHub personal access token"

echo ""
echo "--- Optional Credentials ---"
prompt_var "TELEGRAM_CHAT_ID" "Your Telegram chat ID (send /start to @userinfobot)"
prompt_var "ZENHUB_API_TOKEN" "ZenHub API token (press enter to skip)"
prompt_var "ZENHUB_WORKSPACE_ID" "ZenHub workspace ID (press enter to skip)"
prompt_var "GITHUB_REPO_ID" "GitHub repo ID for ZenHub (press enter to skip)"
prompt_var "NOTION_TOKEN" "Notion integration token (press enter to skip)"
prompt_var "NOTION_SPRINT_DB_ID" "Notion sprint database ID (press enter to skip)"
prompt_var "N8N_WEBHOOK_URL" "n8n base webhook URL (press enter to skip)"

echo ""
echo "--- Credentials saved to $ENV_FILE ---"
echo "IMPORTANT: .env is in .gitignore and will NOT be committed."
echo ""

# --- Install OpenClaw ---

echo "--- OpenClaw Setup ---"
if command -v openclaw &> /dev/null; then
  echo "OpenClaw is already installed: $(openclaw --version)"
else
  echo "Installing OpenClaw..."
  curl -fsSL https://get.openclaw.ai | bash || {
    echo "Auto-install failed. Install manually: https://github.com/openclaw/openclaw"
    echo "Then re-run this script."
  }
fi

# Copy OpenClaw config
if [ -f "$REPO_ROOT/automation/openclaw/openclaw.json" ]; then
  OPENCLAW_CONFIG_DIR="${HOME}/.config/openclaw"
  mkdir -p "$OPENCLAW_CONFIG_DIR"

  echo "Copying OpenClaw config to $OPENCLAW_CONFIG_DIR..."
  cp "$REPO_ROOT/automation/openclaw/openclaw.json" "$OPENCLAW_CONFIG_DIR/openclaw.json"

  # Copy skills
  if [ -d "$REPO_ROOT/automation/openclaw/skills" ]; then
    mkdir -p "$OPENCLAW_CONFIG_DIR/skills"
    cp "$REPO_ROOT/automation/openclaw/skills/"*.md "$OPENCLAW_CONFIG_DIR/skills/"
    echo "Skills copied."
  fi
fi

echo ""
echo "--- n8n Workflow Import ---"
echo "To import the n8n workflows:"
echo "  1. Open your n8n instance"
echo "  2. Go to Workflows → Import from File"
echo "  3. Import each file from: automation/n8n-workflows/"
echo "     - telegram-to-github-issue.json"
echo "     - github-pr-review-notify.json"
echo "     - zenhub-notion-sync.json"
echo "  4. Configure credentials in each workflow node"
echo "  5. Activate the workflows"
echo ""

echo "--- Next Steps ---"
echo "1. Start OpenClaw daemon:  openclaw daemon start"
echo "2. Pair your Telegram:     Send any message to your bot, then run:"
echo "                           openclaw pairing approve telegram <code>"
echo "3. Test the pipeline:      Send '/task Test automation setup' to your Telegram bot"
echo "4. Import n8n workflows:   See instructions above"
echo ""
echo "=== Setup complete ==="
