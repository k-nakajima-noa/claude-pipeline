#!/usr/bin/env bash
PROMPT="$HOME/claude-pipeline/prompts/dev.md"
cat "$PROMPT" | claude mcp serve --add-dir "$(pwd)"