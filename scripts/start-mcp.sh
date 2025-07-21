#!/usr/bin/env bash
set -euo pipefail

CONFIG="$HOME/claude-pipeline/.mcp.json"

jq -r '
  .mcpServers
  | to_entries[]
  | (
      (  # 環境変数列を組み立て
        (.value.env // {})            # env オブジェクト
        | to_entries
        | map("export " + .key + "=" + (.value | @sh))   # → export KEY=VAL
        | join("; ")
      ) as $envs
      |   # コマンド + 引数
        (.value.command | @sh) as $cmd
      | (
          $envs
          + "; "
          + $cmd
          + (
              if (.value.args // []) == []            # 引数なし
              then ""
              else " " + ((.value.args // []) | map(@sh) | join(" "))
              end
            )
        )
    )
' "$CONFIG" |
while IFS= read -r CMD_LINE; do
  # 例: export IPC_SHARED_SECRET='MySecret'; export GITHUB_TOKEN='ghp_x'; npx -y claude-ipc-mcp --secret MySecret
  bash -c "$CMD_LINE" &
done

wait -n      # どれか 1 プロセスが落ちたら終了
