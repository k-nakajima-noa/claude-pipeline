#!/usr/bin/env bash
set -euo pipefail

tmux has-session -t mcp 2>/dev/null && tmux kill-session -t mcp

# ───── ② 旧メッセージ・添付 DB をリセット ──
IPC_DATA_DIR="$HOME/.claude-ipc-data"
rm -f "$IPC_DATA_DIR"/messages.db "$IPC_DATA_DIR"/attachments.db 2>/dev/null || true

tmux new-session -ds mcp " 
  CI=1 uvx --from \$HOME/.claude-ipc-mcp claude-ipc-mcp --secret ${IPC_SHARED_SECRET}"
echo "🚀 MCP サーバー群を tmux セッション[mcp] で起動しました"
echo "   --ipc-connect ws://localhost:9876?secret=${IPC_SHARED_SECRET}"