# harness-mcp-server

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

## Adding a New Tool

1. `src/tools/<name>.ts` に `registerXxxTool(server)` を作成
2. `src/server.ts` でインポート・登録
3. `test/<name>.test.ts` に InMemoryTransport テスト追加 (`test/helpers.ts` の `createTestContext` を使用)

## Commit Rules

コミットルール詳細: `.claude/rules/commit-rules.md`

- 1コミット = 1つの論理的変更。複数の変更を混ぜない
- コミット前に必ず: diff確認 → 矛盾チェック → 修正漏れ確認 → 誤字脱字確認
- テスト + カバレッジ + typecheck + lint が全て通ること

## Prohibited

- `console.log` in src/ — STDIO transport が壊れる。デバッグは `console.error` を使用
- `eval()`, `new Function()`, `child_process.exec` with string interpolation
- Default export（Named export のみ）
- `.env` / `.env.*` ファイルの直接編集
- 設定ファイル (biome.json, tsconfig.json, vitest.config.ts, lefthook.yml, .claude/settings.json) の変更
