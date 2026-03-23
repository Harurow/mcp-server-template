# mcp-server-template

[![CI](https://github.com/Harurow/mcp-server-template/actions/workflows/ci.yml/badge.svg)](https://github.com/Harurow/mcp-server-template/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

[Model Context Protocol (MCP)](https://modelcontextprotocol.io) サーバーテンプレート。ハーネスエンジニアリングのベストプラクティスを組み込み済み。

**[English version](README.md)**

## 特徴

- **TypeScript + strict mode** — `noUncheckedIndexedAccess`, `NodeNext` モジュール解決
- **ハーネスエンジニアリング** — PostToolUse hooks, pre-commit ゲート, CI 品質チェック
- **リンター** — [Oxlint](https://oxc.rs/docs/guide/usage/linter) (lint) + [Biome](https://biomejs.dev) (format)、Rust 製でミリ秒フィードバック
- **テスト** — [Vitest](https://vitest.dev) + MCP SDK の `InMemoryTransport` によるプロトコルレベルテスト
- **プリコミット** — [Lefthook](https://github.com/evilmartians/lefthook) で lint + typecheck + test + coverage をコミット時に強制

## インストール

### npx で直接実行（インストール不要）

```bash
npx my-mcp-server
```

### npm でグローバルインストール

```bash
npm install -g my-mcp-server
my-mcp-server
```

### リポジトリをクローンして使う

```bash
git clone https://github.com/USER/REPO.git
cd REPO
npm install
npm run build
npm run start
```

<!-- TEMPLATE_START -->
## テンプレートとして使う

### GitHub から（推奨）

1. テンプレートから新しいリポジトリを作成:
   ```bash
   gh repo create my-new-mcp --template harurow/mcp-server-template --clone --private
   cd my-new-mcp
   ```

2. 初期化スクリプトでプロジェクト名等をカスタマイズ:
   ```bash
   bash scripts/init.sh my-new-mcp
   ```

3. ブランチ保護を設定（任意）:
   ```bash
   gh repo create my-new-mcp --private --source=. --push  # 未 push の場合
   bash scripts/setup-branch-protection.sh
   ```

### Claude Code から

```bash
/init-mcp-server my-new-mcp
```

### 手動コピー

```bash
cp -r /path/to/mcp-server-template ~/code/my-new-mcp
cd ~/code/my-new-mcp
bash scripts/init.sh my-new-mcp
```

> 初期化後、`scripts/init.sh` は削除され、このセクションも README から除去されます。
<!-- TEMPLATE_END -->

## 開発

```bash
npm run dev          # 開発サーバー起動 (tsx watch)
npm run inspect      # MCP Inspector で動作確認
npm run test         # テスト実行
npm run test:coverage # テスト実行 + カバレッジ (閾値: 80%)
npm run test:watch   # テスト監視モード
npm run lint         # oxlint + biome 実行
npm run typecheck    # tsc --noEmit
npm run build        # dist/ にビルド
```

## ツールの追加方法

1. `src/tools/<name>.ts` を作成:

```typescript
import type { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { z } from "zod";

export function registerMyTool(server: McpServer): void {
  server.tool(
    "my-tool",
    "このツールの説明",
    {
      param: z.string().describe("パラメータの説明"),
    },
    async ({ param }) => {
      return {
        content: [{ type: "text", text: `結果: ${param}` }],
      };
    },
  );
}
```

2. `src/server.ts` で登録:

```typescript
import { registerMyTool } from "./tools/my-tool.js";
registerMyTool(server);
```

3. `test/<name>.test.ts` にテスト追加:

```typescript
import { afterEach, describe, expect, it } from "vitest";
import type { TestContext } from "./helpers.js";
import { createTestContext } from "./helpers.js";

describe("my-tool", () => {
  let ctx: TestContext;
  afterEach(async () => { await ctx.cleanup(); });

  it("期待する結果を返す", async () => {
    ctx = await createTestContext();
    const result = await ctx.client.callTool({
      name: "my-tool",
      arguments: { param: "hello" },
    });
    expect(result.content).toEqual([{ type: "text", text: "結果: hello" }]);
  });
});
```

## MCP クライアント設定

MCP クライアント（例: Claude Desktop）の設定に追加:

```json
{
  "mcpServers": {
    "my-mcp-server": {
      "command": "npx",
      "args": ["-y", "my-mcp-server"]
    }
  }
}
```

グローバルインストール済み、またはローカルクローンの場合:

```json
{
  "mcpServers": {
    "my-mcp-server": {
      "command": "node",
      "args": ["/absolute/path/to/dist/index.js"]
    }
  }
}
```

## プロジェクト構成

```
src/
├── index.ts               # STDIO エントリポイント
├── server.ts              # McpServer 生成 + ツール登録
└── tools/                 # 1ファイル1ツール（ファイル名 = ツール名）
test/
├── helpers.ts             # テストユーティリティ (createTestContext)
└── *.test.ts              # InMemoryTransport によるテスト
docs/adr/                  # Architecture Decision Records
scripts/                   # init.sh, setup-branch-protection.sh
.claude/                   # Hooks, 設定, ルール, スキル
.github/workflows/         # CI パイプライン
biome.json                 # フォーマッター設定 (Biome)
lefthook.yml               # プリコミットフック
tsconfig.json              # TypeScript 設定 (strict)
vitest.config.ts           # テスト設定 + カバレッジ閾値
```

> **Note**: `package.json` に `"private": true` が設定されています。npm に公開する場合は削除してください。

## ブランチ戦略

- `main` — 保護ブランチ。CI パス + PRレビュー必須
- `feat/<name>` — 機能ブランチ。squash merge で main にマージ
- `fix/<name>` — バグ修正ブランチ
- `chore/<name>` — メンテナンス（deps, CI, docs）

詳細は [CONTRIBUTING.md](CONTRIBUTING.md) を参照。

## ライセンス

[MIT](LICENSE)
