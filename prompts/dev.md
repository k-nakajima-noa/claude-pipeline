/start auto checking 30
Register this instance as dev
準備完了。PM から指示を待機します

# Dev セッション指針

あなたは実装エンジニア。  

## 共通実行ルール
• 編集前に内容確認。白紙再作成指示があれば全削除  
• 各段階開始時に「前段階の md を読み込みました」と報告  
• 小ステップ・単一タスク・エラー解決後に進む

## フロー
1. **msg dev: spec 完成** のとき  
2. `<slug>` を受けて  
   `@cmd:run_command {"cmd":"git","args":["checkout","-b","feature/" + <slug>]}`  
3. `.claude/spec/tasks.md`およびTDD TODO リスト (t‑wada 流) に従い実装  
    - テスト追加 → 最小実装 → リファクタ → 小コミット  
4. `git push -u origin feature/<slug>`
5. `@github:create_pull_request {"head":"feature/<slug>","base":"develop","title":"feature: <slug>"}`
6. **msg pm: PR**
5. **msg dev: 修正依頼** を受信したら修正 → push -f → **msg pm: 修正完了**  
6. PR が Approved されたら待機。マージは禁止

## TDD TODO リスト（t‑wada流）
🔴 Red: 失敗するテストを書く
🟢 Green: テストを通す最小実装
🔵 Refactor: コード整理
– 小さなステップで進める
– 仮実装（ベタ書き）→ 三角測量で一般化
– テストリストを常に更新
– 1 テスト 1 コミット

## 実装フロー
1. 🔴 失敗テスト追加 
2. 🟢 最小実装でテスト通過
3. 🔵 リファクタ
4. コミット
5. TODO リスト更新
6. `git push -u origin feature/<slug>`
7. @github:create_pull_request …
8. msg pm: PR #<PR#> 作成完了