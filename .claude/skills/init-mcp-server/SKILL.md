---
name: init-mcp-server
description: MCP Server テンプレートから新しいプロジェクトを初期化する
user-invocable: true
argument-hint: "<server-name> [dest] [github-owner]"
---

# MCP Server 初期化スキル

テンプレート (`~/code/mcp-server-template`) から新しい MCP Server プロジェクトを作成する。

## 引数

- `$0` — server-name (必須, kebab-case, e.g. `my-awesome-mcp`)
- `$1` — dest (省略時: `~/code/<server-name>`)
- `$2` — github-owner (省略時: `gh api user -q '.login'` で自動取得)

## 手順

1. **引数を検証する**
   - `$0` (server-name) が kebab-case であることを確認 (`^[a-z][a-z0-9-]*$`)
   - `$1` (dest) が未指定なら `~/code/$0` をデフォルトにする
   - `$2` (github-owner) が未指定なら `gh api user -q '.login'` で自動取得。取得できなければ `USER` のまま残す
   - 作成先が既に存在する場合はユーザーに確認する

2. **テンプレートをコピーする**
   `.git/`, `node_modules/`, `dist/`, `coverage/` を除外してコピー:
   ```bash
   rsync -a --exclude='.git' --exclude='node_modules' --exclude='dist' --exclude='coverage' ~/code/mcp-server-template/ <dest>/
   ```

3. **プロジェクト名を置換する**
   以下のファイル内の `my-mcp-server` を `<server-name>` に一括置換:
   - `package.json` (name + bin)
   - `src/server.ts` (McpServer name)
   - `CLAUDE.md`, `AGENTS.md`, `README.md`, `README.ja.md`, `CHANGELOG.md`, `.env.example`

4. **GitHub URL プレースホルダーを置換する**
   `README.md`, `README.ja.md`, `CHANGELOG.md` 内の `USER/REPO` を `<github-owner>/<server-name>` に置換
   `cd REPO` を `cd <server-name>` に置換

5. **LICENSE の著作者名を更新する**
   `harurow` を `<github-owner>` に置換

6. **サンプルツールを削除する**
   - `src/tools/greet.ts` と `test/greet.test.ts` を削除
   - `src/server.ts` を空のツール登録に書き換える:
     ```typescript
     import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";

     export function createServer(): McpServer {
       const server = new McpServer({
         name: "<server-name>",
         version: "0.1.0",
       });

       return server;
     }
     ```

7. **init スクリプトを削除する**（初期化済みプロジェクトには不要）
   ```bash
   rm -f scripts/init.sh
   ```
   `scripts/setup-branch-protection.sh` は残す

8. **テンプレート固有の ADR を削除し、プロジェクト用 ADR を生成する**
   - 以下のテンプレート固有 ADR を削除する:
     - `docs/adr/0001-harness-engineering-setup.md`
     - `docs/adr/0002-template-vs-project-values.md`
   - `docs/adr/0000-template.md` は残す（ADR テンプレート）
   - `docs/adr/0001-technology-stack.md` を以下の内容で生成する:

     ```markdown
     # ADR-0001: 技術スタック選定

     - Status: Accepted
     - Date: <初期化実行日>

     ## Context

     MCP Server の開発基盤として、品質・速度・AI エージェントとの親和性を重視して技術スタックを選定する必要がある。

     ## Decision

     | カテゴリ | 選定 | 却下した代替案 | 理由 |
     |---------|------|--------------|------|
     | テストフレームワーク | vitest | Jest | ESM ネイティブ対応、TypeScript 設定不要、高速 |
     | リンター | Oxlint | ESLint | Rust 製で高速、PostToolUse Hook での自動実行に適合 |
     | フォーマッター | Biome | Prettier | Rust 製で高速、リンターとフォーマッターを一体化可能 |
     | プリコミットフック | Lefthook | husky + lint-staged | 設定がシンプル、並列実行対応、Go 製で高速 |
     | 入力バリデーション | Zod | joi, yup, io-ts | TypeScript 型推論との統合が最も優れている |

     ### 追加の設計判断

     - **`console.log` 禁止**: MCP は STDIO transport を使用するため、stdout への出力はプロトコルを破壊する。デバッグ出力は `console.error` (stderr) を使用する
     - **`any` 型禁止**: 外部入力は `unknown` で受け取り、Zod でパースすることで型安全性を確保する
     - **Named export のみ**: Default export はリファクタリング時の追跡が困難で、ツリーシェイキングにも不利

     ## Consequences

     - Rust/Go 製ツールの採用により、CI とローカルフックの実行速度が大幅に向上する
     - Zod スキーマが入力バリデーションと TypeScript 型定義の Single Source of Truth となる
     - ESLint/Prettier エコシステムのプラグイン資産は利用できないが、MCP Server の規模では問題にならない
     ```

9. **Git を初期化する**
   ```bash
   cd <dest>
   git init
   ```

10. **依存関係をインストールする**
   ```bash
   npm install
   npx lefthook install
   ```

11. **検証する**
    ```bash
    npx tsc --noEmit
    npx oxlint src/ && npx biome check src/
    ```

12. **初期コミットを作成する**（テストファイルがないため `--no-verify` を使用）
    ```bash
    git add -A
    git commit -m "Initial commit from mcp-server template" --no-verify
    ```

13. **npm 公開予定がある場合**
    `package.json` の `"private": true` を削除する旨を案内する

14. **次のステップを案内する**
    完了後、以下を伝える:
    - `src/tools/<name>.ts` にツールを追加
    - `src/server.ts` で登録
    - `test/<name>.test.ts` にテスト追加 (`createTestContext` を使用)
    - `npm run dev` で開発サーバー起動
    - `npm run inspect` で MCP Inspector から動作確認
    - GitHub リポジトリ作成: `gh repo create <server-name> --private --source=. --push`
    - ブランチ保護設定: `bash scripts/setup-branch-protection.sh`
