#!/usr/bin/env bash
PROMPT="$HOME/claude-pipeline/prompts/dev.md"
exec claude mcp serve --add-dir "$(pwd)" < "$PROMPT"