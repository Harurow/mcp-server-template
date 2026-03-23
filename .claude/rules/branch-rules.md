# Branch Rules

## ブランチ命名規則

```
feat/<name>   — 機能追加
fix/<name>    — バグ修正
chore/<name>  — メンテナンス（deps, CI, docs）
```

- `<name>` は kebab-case（例: `feat/add-search-tool`, `fix/empty-input-validation`）
- `main` に直接コミット・push しない。必ず feature branch → PR → squash merge

## ワークフロー

1. `main` から branch を切る: `git checkout -b feat/<name> main`
2. 開発・コミット（1コミット = 1論理変更。詳細: `.claude/rules/commit-rules.md`）
3. push: `git push -u origin feat/<name>`
4. PR 作成: `gh pr create`
5. CI pass + レビュー承認 → squash merge

## マージルール

- マージ方法: **Squash merge のみ**（1 PR = main 上で 1 commit）
- マージ条件:
  - CI (lint + typecheck + test + coverage) が全て pass
  - 1人以上のレビュー承認
- マージ後: feature branch を削除する

## 禁止事項

- `main` への直接 push
- `git push --force`（deny ルールで機械的にブロック済み）
- `git commit --no-verify`（deny ルールで機械的にブロック済み）
