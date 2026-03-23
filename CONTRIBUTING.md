# Contributing

## Branch Strategy

```
main (protected)
 ├── feat/<name>    Feature branches
 ├── fix/<name>     Bug fix branches
 └── chore/<name>   Maintenance (deps, CI, docs)
```

- `main` へ直接 push は禁止（branch protection で強制）
- PR は全て `main` に対して作成
- マージ方法: **Squash merge** （1 PR = 1 commit で履歴をクリーンに保つ）
- マージ条件:
  - CI (lint + typecheck + test + coverage) が全て pass
  - 1人以上のレビュー承認

## Commit Rules

**1コミット = 1つの論理的変更** を厳守する。

### 分けるべき変更

| 別コミットにする | 例 |
|---|---|
| 機能追加 と バグ修正 | `feat: add search tool` + `fix: handle empty input in greet` |
| リファクタリング と 機能変更 | `refactor: extract validation` + `feat: add length check` |
| 依存関係更新 と コード変更 | `chore: update zod to 3.25` + `feat: use new zod feature` |
| フォーマット修正 と 実質変更 | `chore: format files` + `fix: correct return type` |

### コミット前チェックリスト

1. `git diff --staged` で変更内容を確認
2. 変更ファイル間の矛盾がないか（import パス、登録漏れ等）
3. リネーム・移動時に参照元が全て更新されているか
4. コメント・文字列・ドキュメントに誤字脱字がないか
5. `npm run test:coverage` — テスト通過 + カバレッジ 80% 以上
6. `npm run typecheck` — 型エラーなし
7. `npm run lint` — lint エラーなし

### Commit Message Format

```
<type>: <description>
```

Types: `feat`, `fix`, `chore`, `docs`, `refactor`, `test`

「何を」ではなく「なぜ」を書く。命令形で始める。

## Development Flow

1. `main` から feature branch を切る:
   ```bash
   git checkout -b feat/my-feature main
   ```

2. 開発・テスト:
   ```bash
   npm run dev          # 開発サーバー
   npm run test:watch   # テスト監視
   ```

3. コミット (pre-commit hook が自動で lint + typecheck + test + coverage を実行):
   ```bash
   git add <files>
   git commit -m "feat: add my feature"
   ```

4. Push & PR 作成:
   ```bash
   git push -u origin feat/my-feature
   gh pr create
   ```

## Adding a Tool

1. `src/tools/<name>.ts` — 1ファイル1ツール、named export のみ
2. `src/server.ts` — ツール登録
3. `test/<name>.test.ts` — `createTestContext()` を使ったテスト
4. CHANGELOG.md の `[Unreleased]` セクションに追記

## Architecture Decision Records (ADR)

設計上の判断は `docs/adr/` に ADR として記録する。テンプレート: `docs/adr/0000-template.md`

### ADR を書くべきとき

- 複数の選択肢を比較検討して判断した場合（例: ライブラリ選定、アーキテクチャ方針）
- コードだけでは「なぜそうしたか」が分からない設計判断（例: プレースホルダー戦略の変更）
- 将来のメンテナで同じ議論を繰り返さないために記録が必要な場合
- バグや問題の根本原因が設計上の判断に起因する場合

### ADR を書かなくてよいとき

- 単純なバグ修正（コミットメッセージで十分）
- 明らかに一択しかない変更
- 一時的なワークアラウンド（Issue で追跡する）

### フォーマット

採番: `0001-` から連番。状態: `Proposed` → `Accepted` → `Superseded` or `Deprecated`

## Quality Gates

Pre-commit (Lefthook) と CI の両方で以下を強制:

| Check | Command | Blocking |
|-------|---------|----------|
| Lint | `oxlint src/ test/` | Yes |
| Format | `biome check src/ test/` | Yes |
| Type check | `tsc --noEmit` | Yes |
| Test + Coverage | `vitest run --coverage` (閾値: 80%) | Yes |
