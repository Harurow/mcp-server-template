# Deprecated Rules

## 基本方針

非推奨 (deprecated) とマークされた API・パッケージ・機能は使用しない。
AI エージェントの学習データには非推奨の古いコード例が多く含まれるため、特に注意が必要。

## 具体的なルール

### Node.js API

- 非推奨の Node.js API を使用しない（例: `url.parse()` → `new URL()`, `Buffer()` → `Buffer.from()`）
- 新しいコードでは現行の安定版 API を使用する
- 判断に迷う場合は [Node.js 公式ドキュメント](https://nodejs.org/api/) の Stability 表記を確認する

### npm パッケージ

- npm で deprecated とマークされたパッケージを新規導入しない
- 既存の依存関係が deprecated になった場合は、推奨される後継パッケージへ移行する
- パッケージ追加前に `npm info <package>` で deprecated 状態を確認する

### TypeScript

- 非推奨の TypeScript コンパイラオプションを使用しない
- 非推奨の型ユーティリティやパターンを避ける

### MCP SDK

- `@modelcontextprotocol/sdk` の非推奨 API を使用しない
- SDK のマイグレーションガイドに従い、推奨されるパターンを使用する

## 発見時の対応

- 新規コードで非推奨機能を使っている場合: 現行の代替手段に置き換える
- 既存コードで非推奨機能を発見した場合: その場で修正するか、Issue を作成して追跡する
- 非推奨かどうか不明な場合: 公式ドキュメントを確認してから使用する
