#!/usr/bin/env bash

# ========== 📌 実行場所確認 ==========
# このスクリプトは「開発リポジトリ」から呼び出される前提

# Claude Pipeline 側（このスクリプト自身が属するディレクトリを基準に）
CLAUDE_PIPELINE_ROOT="$HOME/claude-pipeline"
PROMPT_PM="$CLAUDE_PIPELINE_ROOT/prompts/pm.md"
PROMPT_DEV="$CLAUDE_PIPELINE_ROOT/prompts/dev.md"

# Claude CLI 実行ディレクトリ（＝現在の開発リポジトリ）
TARGET_REPO_PATH="$(pwd)"
CLAUDE_CMD="claude --add-dir $TARGET_REPO_PATH"

SESSION="claude"

# Claude CLI用 環境変数（必要に応じて .env 読み込みしても良い）
export CLAUDE_MCP_UPSTREAM="ws://127.0.0.1:9876?secret=$IPC_SHARED_SECRET"
export CI=0  # Rawモード有効化のため明示的に無効化

# ========== 🧩 tmux セッション起動 ==========

tmux kill-session -t "$SESSION" 2>/dev/null

tmux new-session -d -s "$SESSION" -n pm "$CLAUDE_CMD"
tmux split-window -h -t "$SESSION:0" "$CLAUDE_CMD"

# ========== ⌨️ プロンプト送信 ==========

sleep 1  # Claude CLI 起動待ち

tmux send-keys -t "$SESSION:0.0" "$(cat "$PROMPT_PM")" C-m
tmux send-keys -t "$SESSION:0.1" "$(cat "$PROMPT_DEV")" C-m

# ========== 🪟 セッション表示 ==========

tmux attach-session -t "$SESSION"
