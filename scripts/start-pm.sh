#!/usr/bin/env bash
PROMPT_FILE="$HOME/claude-pipeline/prompts/pm.md"

# ❶ claude を起動（標準入力はまだ空）
export CLAUDE_MCP_UPSTREAM="ws://127.0.0.1:9876?secret=$IPC_SHARED_SECRET"
export CI=1
cat "$PROMPT_FILE" \
| claude --add-dir $(pwd)