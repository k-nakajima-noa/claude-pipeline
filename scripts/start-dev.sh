#!/usr/bin/env bash
PROMPT_CONTENT="$(cat "$HOME/claude-pipeline/prompts/dev.md")"
exec claude --add-dir "$(pwd)" "$PROMPT_CONTENT"