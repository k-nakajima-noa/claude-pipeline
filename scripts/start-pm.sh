#!/usr/bin/env bash
PROMPT_CONTENT="$(cat "$HOME/claude-pipeline/prompts/pm.md")"
exec claude --add-dir "$(pwd)" "$PROMPT_CONTENT"