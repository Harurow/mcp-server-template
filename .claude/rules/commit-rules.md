# Commit Rules

## コミット前セルフレビュー（必須）

コミットを作成する前に、以下を必ず確認する:

1. **差分の確認**: `git diff --staged` で変更内容を全て確認し、意図しない変更が含まれていないことを確認する
2. **矛盾チェック**: 変更したファイル間で矛盾がないか確認する（例: server.ts でツールを登録したが tools/ にファイルがない、test を追加したが import が間違っている等）
3. **修正漏れ**: リネームや移動を行った場合、参照元が全て更新されているか確認する（import パス、CLAUDE.md/AGENTS.md の記述、README 等）
4. **ドキュメント同期**: 機能の追加・変更・削除に伴い、関連ドキュメント（README.md, README.ja.md, CLAUDE.md, AGENTS.md, CHANGELOG.md, docs/adr/）が更新されているか確認する
5. **誤字脱字**: 変更差分内のコメント、文字列リテラル、ドキュメントに誤字脱字がないか確認する
6. **テスト**: `npm run test` が通ること。新しいコードにはテストがあること
7. **カバレッジ**: `npm run test:coverage` でカバレッジ閾値（80%）を満たしていること
8. **型チェック**: `npm run typecheck` が通ること
9. **lint**: `npm run lint` が通ること

## コミット粒度

- **1コミット = 1つの論理的変更** を厳守する
- 以下は別コミットに分ける:
  - 機能追加とバグ修正
  - リファクタリングと機能変更
  - 依存関係の更新とコード変更
  - フォーマット修正と実質的な変更
- 迷ったら分ける。大きすぎるコミットより小さすぎるコミットの方が良い

## コミットメッセージ

```
<type>: <description>
```

- type: `feat`, `fix`, `chore`, `docs`, `refactor`, `test`
- description: 変更の「何を」ではなく「なぜ」を書く。命令形で始める
- 日本語・英語どちらでも可。1プロジェクト内では統一する

### 例

```
feat: add search tool with fuzzy matching
fix: prevent empty name from passing Zod validation
refactor: extract test helper into shared module
chore: update @modelcontextprotocol/sdk to 1.13.0
```

### NG 例

```
fix: fix bug                    # 何のバグか不明
update files                    # type なし、内容不明
feat: add tool and fix test     # 2つの変更が混在
```
