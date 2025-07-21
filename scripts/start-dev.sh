#!/usr/bin/env bash
PROMPT_FILE="$HOME/claude-pipeline/prompts/dev.md"
PANE=$(tmux display-message -p '#{pane_id}')

claude --add-dir "$(pwd)" &

PID=$!
sleep 0.2

tmux load-buffer "$PROMPT_FILE"
tmux paste-buffer -t "$PANE"
tmux send-keys    -t "$PANE" C-m

wait "$PID"