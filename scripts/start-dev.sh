#!/usr/bin/env bash
PROMPT_FILE="$HOME/claude-pipeline/prompts/dev.md"
PANE=$(tmux display-message -p '#{pane_id}')

CLAUDE_MCP_UPSTREAM="ws://127.0.0.1:9876?secret=$IPC_SHARED_SECRET" \
claude --add-dir "$(pwd)" &

PID=$!
sleep 0.3

tmux load-buffer "$PROMPT_FILE"
tmux paste-buffer -t "$PANE"
tmux send-keys    -t "$PANE" C-m C-m

wait "$PID"