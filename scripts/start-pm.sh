#!/usr/bin/env bash
PROMPT="$HOME/claude-pipeline/prompts/pm.md"
exec claude mcp serve \
     --identity pm \
     --load-prompt "$PROMPT" \
     --start-auto-check 10 \
     --working-dir "$(pwd)"