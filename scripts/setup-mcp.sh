#!/usr/bin/env bash
set -euo pipefail

MCP_DIR="$HOME/.claude-ipc-mcp"
SECRET_ENV="IPC_SHARED_SECRET"

# ── 1. 前提ツール ──────────────────────────
command -v uv >/dev/null || curl -LsSf https://astral.sh/uv/install.sh | sh
command -v claude >/dev/null || { echo "❌ Claude CLI 未インストール"; exit 1; }

# ── 2. リポジトリ取得 & 依存解決 ────────────
if [[ -d "$MCP_DIR" ]]; then git -C "$MCP_DIR" pull --quiet
else git clone --depth 1 https://github.com/jdez427/claude-ipc-mcp.git "$MCP_DIR"; fi
cd "$MCP_DIR" && uv sync          # Poetry 互換依存を解決

# ── 3. シークレット生成 (無ければ) ───────────
if [[ -z "${!SECRET_ENV:-}" ]]; then
  export $SECRET_ENV="$(openssl rand -hex 16)"
  echo "export $SECRET_ENV=${!SECRET_ENV}" >> ~/.bashrc
  echo "[setup] 生成した $SECRET_ENV=${!SECRET_ENV}"
fi

# ── 4. MCP 設定ファイルを生成 ────────────────
./scripts/install-mcp.sh

# ── 5. 追加 MCP サーバー登録 (重複チェック) ──
if ! claude mcp list | grep -q '^cmd '; then
  claude mcp add cmd \
    -e ALLOWED_COMMANDS=git \
    -e $SECRET_ENV=${!SECRET_ENV} \
    npx -y mcp-server-commands
fi

if ! claude mcp list | grep -q '^github '; then
  claude mcp add github \
    -e GITHUB_TOKEN=$GITHUB_TOKEN \
    -e $SECRET_ENV=${!SECRET_ENV} \
    npx -y @modelcontextprotocol/server-github
fi

echo "✅  セットアップ完了。次回からは start-mcp.sh を実行してください。"
