#!/usr/bin/env bash
PROMPT_FILE="$HOME/claude-pipeline/prompts/dev.md"
PANE=$(tmux display-message -p '#{pane_id}')

export CLAUDE_MCP_UPSTREAM="ws://127.0.0.1:9876?secret=$IPC_SHARED_SECRET"
export CI=1
claude --add-dir "$(pwd)" | cat &

PID=$!
sleep 0.3

tmux load-buffer "$PROMPT_FILE"
tmux paste-buffer -t "$PANE"
tmux send-keys    -t "$PANE" C-m C-m

wait "$PID"