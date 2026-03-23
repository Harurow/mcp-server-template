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

8. **Git を初期化する**
   ```bash
   cd <dest>
   git init
   ```

9. **依存関係をインストールする**
   ```bash
   npm install
   npx lefthook install
   ```

10. **検証する**
    ```bash
    npx tsc --noEmit
    npx oxlint src/ && npx biome check src/
    ```

11. **初期コミットを作成する**（テストファイルがないため `--no-verify` を使用）
    ```bash
    git add -A
    git commit -m "Initial commit from mcp-server template" --no-verify
    ```

12. **npm 公開予定がある場合**
    `package.json` の `"private": true` を削除する旨を案内する

13. **次のステップを案内する**
    完了後、以下を伝える:
    - `src/tools/<name>.ts` にツールを追加
    - `src/server.ts` で登録
    - `test/<name>.test.ts` にテスト追加 (`createTestContext` を使用)
    - `npm run dev` で開発サーバー起動
    - `npm run inspect` で MCP Inspector から動作確認
    - GitHub リポジトリ作成: `gh repo create <server-name> --private --source=. --push`
    - ブランチ保護設定: `bash scripts/setup-branch-protection.sh`
