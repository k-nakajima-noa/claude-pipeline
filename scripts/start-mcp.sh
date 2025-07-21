#!/usr/bin/env bash
set -euo pipefail

tmux has-session -t mcp 2>/dev/null && tmux kill-session -t mcp
tmux new-session -ds mcp "
  CI=1 uvx --from \$HOME/.claude-ipc-mcp claude-ipc-mcp --secret ${IPC_SHARED_SECRET}
echo "🚀 MCP サーバー群を tmux セッション[mcp] で起動しました"
echo "   --ipc-connect ws://localhost:9876?secret=${IPC_SHARED_SECRET}"