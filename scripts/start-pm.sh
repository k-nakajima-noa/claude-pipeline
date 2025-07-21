#!/usr/bin/env bash
PROMPT="$HOME/claude-pipeline/prompts/pm.md"
exec claude mcp serve --add-dir "$(pwd)" < "$PROMPT"