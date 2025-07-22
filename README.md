# Claude Code ― PM / Dev Dual‑Session Pipeline

## 1. 目的
- **PM セッション**
  要件定義 → 設計 → タスク分解 → レビュー・承認 までを自動化する “擬似プロダクトマネージャー”。
- **Dev セッション**
  PM からの指示を受けて TDD で実装・コミット・PR を作成する “擬似開発者”。

両者を **tmux 2 ペインで並列起動** し、`msg dev:` / `msg pm:` による相互通信で
完全な開発フローを自律的に回します。

---

## 2. ディレクトリ構成

```
claude-pipeline/
├─ prompts/
│  ├─ pm.md          # PM 指針 + 登録行
│  └─ dev.md         # Dev 指針 + 登録行
├─ scripts/
│  ├─ setup-mcp.sh     # 初回のみ
│  ├─ start-mcp.sh     # MCP ハブ常駐 (tmux\:mcp)
│  └─ start-claude.sh  # PM/Dev セッション一括起動
└─ README.md         # ← (このファイル)
````

---

## 3. 事前準備（初回のみ）

```bash
# 1. セットアップ
bash ~/claude-pipeline/scripts/setup-mcp.sh

# 2. 必要環境変数（~/.bashrc に自動追記される）
export IPC_SHARED_SECRET=<自動生成>
export GITHUB_TOKEN=<Personal Access Token>
````

> `claude login` でブラウザ認証を済ませておくこと。
> Node.js v22.14.0+ / UV / tmux がインストールされている前提。

---

## 4. 起動方法（毎回）

```bash
# (A) MCP サーバー群を常駐
bash ~/claude-pipeline/scripts/start-mcp.sh # tmux セッション[mcp]

# (B) プロジェクト側で PM / Dev
cd ~/projects/your-repo
bash ~/claude-pipeline/scripts/start-claude.sh
```

| ペイン     | 内容                                          |
| ------- | ------------------------------------------- |
| 上 (pm)  | `Register this instance as pm` → 準備完了メッセージ  |
| 下 (dev) | `Register this instance as dev` → 準備完了メッセージ |

上ペインに要件を 1 行入力するとフローが開始し、
`msg dev:` / `msg pm:` によって自動で往復します。

---

## 5. スクリプト要点

| ファイル                           | 役割                                                   | 主な実装ポイント                                                            |
| ------------------------------ | ---------------------------------------------------- | ------------------------------------------------------------------- |
| **setup-mcp.sh**     | claude‑ipc‑mcp clone / uv sync / mcp add 登録を一括       | idempotent（再実行安全）                                                   |
| **start‑mcp.sh**     | `uvx … claude-ipc-mcp --port 9876` を tmux\[mcp] で常駐  |                                    |
| **start‑claude.sh**  | tmux水平分割でPM/Devを起動、初期プロンプト自動送信           | `CLAUDE_MCP_UPSTREAM=ws://127.0.0.1:9876?secret=$IPC_SHARED_SECRET` |

---

## 6. よくあるエラーと対処

| 症状                                            | 原因                      | 対処                                                      |
| --------------------------------------------- | ----------------------- | ------------------------------------------------------- |
| `Raw mode is not supported …`                 | stdin が非 TTY            | `tmux send-keys` で直接入力送信                             |
| `Message queued for dev (not yet registered)` | Dev が未登録                | prompts/dev.md 冒頭に `Register this instance as dev` を入れる |
| tmux セッションが既に存在                          | 前回セッションが残存            | `tmux kill-session -t claude` で削除してから再実行           |

---

## 7. Tips

* **マウス操作**: `set -g mouse on` を `~/.tmux.conf` に入れるとペイン切替が楽。
* **ベル通知**: プロンプトの最後に `\a` を挿入すると承認時に端末ベルが鳴る。
* **Node.js 切替**: `nvm install 22.14.0 && nvm alias default 22.14.0`
