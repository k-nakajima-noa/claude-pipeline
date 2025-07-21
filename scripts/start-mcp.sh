#!/usr/bin/env bash
set -euo pipefail

CONFIG="$HOME/claude-pipeline/.mcp.json"

jq -r '
  .mcpServers
  | to_entries[]
  | (
      # 環境変数を "KEY=VAL" 形式で組み立てて配列化
      ([ (.value.env // {}) | to_entries[] | "export " + .key + "=" + @sh (.value) ] | join("; "))
      + "; " +
      # コマンド本体
      @sh (.value.command) +
      # 引数
      ( " " + ((.value.args // []) | map(@sh) | join(" ")) )
    )' "$CONFIG" |
while IFS= read -r CMD_LINE; do
  # 例: export IPC_SHARED_SECRET='MySecret'; export GITHUB_TOKEN='ghp_x'; npx -y claude-ipc-mcp --secret MySecret
  bash -c "$CMD_LINE" &
done

# どれか 1 プロセスが落ちたら全体を終了させる
wait -n