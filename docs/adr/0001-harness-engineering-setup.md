# ADR-0001: ハーネスエンジニアリング導入

- Status: Accepted
- Date: 2026-03-23

## Context

MCP Server 開発において、AIコーディングエージェントが自律的かつ高品質にコードを生産できる環境を構築する。
参考: https://nyosegawa.com/posts/harness-engineering-best-practices-2026/

## Decision

- **リンター**: Oxlint (lint) + Biome (format) — Rust製で高速、PostToolUse Hook に適合
- **型チェック**: TypeScript strict mode + `noUncheckedIndexedAccess`
- **プリコミット**: Lefthook で lint + typecheck + test 強制
- **Hooks**: PostToolUse で自動フォーマット+リント、PreToolUse でリンター設定保護、Stop でテスト実行
- **CLAUDE.md**: 50行以下、ポインタのみ
- **テスト**: vitest

## Consequences

- エージェントはファイル編集のたびに自動的にフォーマット+リントされる
- リンター設定の改変は構造的にブロックされる
- `git commit --no-verify` は禁止され、プリコミットフックのバイパス不可
