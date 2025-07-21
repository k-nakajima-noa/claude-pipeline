#!/usr/bin/env bash
PROMPT_CONTENT="$(cat "$HOME/claude-pipeline/prompts/pm.md")"
exec claude mcp serve --add-dir "$(pwd)" "$PROMPT_CONTENT"