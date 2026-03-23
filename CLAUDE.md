# my-mcp-server

MCP (Model Context Protocol) server — Node.js + TypeScript.
Cross-agent instructions: @AGENTS.md

## Build / Test / Lint

```bash
npm run build         # tsc
npm run test          # vitest run
npm run test:coverage # vitest run --coverage (閾値: 80%)
npm run lint          # oxlint + biome check
npm run typecheck     # tsc --noEmit
npm run dev           # tsx watch (dev server)
npm run start         # node dist/index.js
npm run inspect       # MCP Inspector で動作確認
```

## Architecture Rules

- src/tools/ に1ファイル1ツール配置。ファイル名 = ツール名
- ツール定義は Zod スキーマで入力バリデーション必須
- エラーは McpError を使用。生の throw 禁止
- `any` 型禁止。不明な外部入力は `unknown` → Zod parse
- ADR: docs/adr/ (採番: 0001-, 状態: Proposed/Accepted/Superseded/Deprecated)
  - 以下の場合に ADR を作成すること:
    - 複数の選択肢を比較検討して判断した場合
    - コードだけでは「なぜそうしたか」が分からない設計判断
    - 将来のメンテナで同じ議論を繰り返さないために記録が必要な場合
    - バグや問題の根本原因が設計上の判断に起因する場合

## Adding a New Tool

1. `src/tools/<name>.ts` に `registerXxxTool(server)` を作成
2. `src/server.ts` でインポート・登録
3. `test/<name>.test.ts` に InMemoryTransport テスト追加 (`test/helpers.ts` の `createTestContext` を使用)

## Documentation Sync

- 機能追加・変更・削除時は、関連するドキュメントを必ず同じ PR 内で更新する
  - 対象: README.md, README.ja.md, CLAUDE.md, AGENTS.md, CHANGELOG.md, docs/adr/
- ドキュメントだけが古い場合も修正対象。見つけたら放置せず PR を作成する

## Proactive Improvement

- バグ・不整合・改善点を発見した場合は、積極的に feature branch を切って修正 PR を作成する
- 「気づいたが放置」より「小さくても PR を出す」を優先する
- 修正範囲が大きい場合は Issue を作成して追跡する
- 修正が設計判断を伴う場合（ADR 作成基準に該当する場合）は ADR も同じ PR に含める

## Commit Rules

コミットルール詳細: `.claude/rules/commit-rules.md`

- 1コミット = 1つの論理的変更。複数の変更を混ぜない
- コミット前に必ず: diff確認 → 矛盾チェック → 修正漏れ確認 → ドキュメント同期確認 → 誤字脱字確認
- テスト + カバレッジ + typecheck + lint が全て通ること

## Prohibited

- `console.log` in src/ — STDIO transport が壊れる。デバッグは `console.error` を使用
- `eval()`, `new Function()`, `child_process.exec` with string interpolation
- Default export（Named export のみ）
- `.env` / `.env.*` ファイルの直接編集
- 設定ファイル (biome.json, tsconfig.json, vitest.config.ts, lefthook.yml, .claude/settings.json) の変更
- 非推奨 (deprecated) な API・パッケージ・機能の使用。詳細: `.claude/rules/deprecated-rules.md`
