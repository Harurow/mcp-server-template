# ADR-0002: テンプレートリポジトリ固有値とプレースホルダーの分離

- Status: Accepted
- Date: 2026-03-24

## Context

README の CI バッジ URL やタイトルに `USER/REPO` というプレースホルダーを使用していた。これは `init.sh` による初期化時に置換される前提だが、テンプレートリポジトリ自体を GitHub で公開すると、バッジが壊れた状態で表示される問題が発生した。

テンプレートには2種類の値が混在している:

1. **テンプレートリポジトリ自体の値** — GitHub 上でテンプレートとして公開される際に正しく表示される必要がある（例: リポジトリ名、CI バッジ URL）
2. **初期化後のプロジェクト用プレースホルダー** — `init.sh` で置換される値（例: パッケージ名 `harness-mcp-server`、MCP クライアント設定内の名前）

この2つを区別せず同じプレースホルダー方式で管理していたため、テンプレートリポジトリの README が壊れた状態になっていた。

## Decision

- README のタイトルと CI バッジ URL には **テンプレートリポジトリの実際の値** を使用する（`mcp-server-template`, `Harurow/mcp-server-template`）
- `init.sh` では、テンプレート固有値（`mcp-server-template`, `Harurow/mcp-server-template`）とプレースホルダー（`harness-mcp-server`, `USER/REPO`）の **両方を** 新プロジェクトの値に置換する
- テンプレート専用セクション（使い方ガイド等）は `<!-- TEMPLATE_START -->` / `<!-- TEMPLATE_END -->` で囲み、`init.sh` で丸ごと削除する

## Consequences

- テンプレートリポジトリの GitHub ページで CI バッジや README が正しく表示される
- `init.sh` の置換ロジックが2段階（テンプレート固有値 + プレースホルダー）になり、やや複雑になる
- テンプレートに新しい URL やリポジトリ名の参照を追加する際は、`init.sh` の置換対象に含めることを忘れないようにする必要がある
