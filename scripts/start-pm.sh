#!/usr/bin/env bash
PROMPT_FILE="$HOME/claude-pipeline/prompts/pm.md"

# 自分の pane_id を取得
PANE=$(tmux display-message -p '#{pane_id}')

# ❶ claude を起動（標準入力はまだ空）
CLAUDE_MCP_UPSTREAM="ws://127.0.0.1:9876?secret=$IPC_SHARED_SECRET" \
claude --add-dir "$(pwd)" &

PID=$!
sleep 0.3   # プロセスがターミナル制御を取るのを待つ

# ❷ プロンプト全文を tmux バッファに読み込み → 自 pane に貼り付け → Enter
tmux load-buffer "$PROMPT_FILE"
tmux paste-buffer -t "$PANE"
tmux send-keys    -t "$PANE" C-m C-m

wait "$PID"