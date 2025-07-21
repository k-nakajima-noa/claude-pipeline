#!/usr/bin/env bash
PROMPT="$HOME/claude-pipeline/prompts/dev.md"
exec claude mcp serve \
     --identity dev \
     --load-prompt "$PROMPT" \
     --start-auto-check 30 \
     --working-dir "$(pwd)"