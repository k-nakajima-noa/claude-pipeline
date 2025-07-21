#!/usr/bin/env bash
PROMPT="$HOME/claude-pipeline/prompts/pm.md"
cat "$PROMPT" | claude mcp serve --add-dir "$(pwd)"