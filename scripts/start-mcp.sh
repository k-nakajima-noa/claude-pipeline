#!/usr/bin/env bash
CONFIG="$HOME/claude-pipeline/.mcp.json"

jq -r '
  .mcpServers as $s |
  keys[] |
  ($s[.] | "\(.command) \(.args[]?)")'  "$CONFIG" |
while read -r CMD; do
  # each line: `npx -y ...`
  (eval "$CMD" &)   # 実際にバックグラウンド起動
done

wait -n             # どれか落ちたら全体終了
