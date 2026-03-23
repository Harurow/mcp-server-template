---
name: clean-template
description: 初期化済みプロジェクトからテンプレート固有の残留物を削除する
user-invocable: true
argument-hint: ""
---

# テンプレートクリーンアップスキル

`init.sh` または `/init-mcp-server` で初期化済みのプロジェクトから、テンプレート固有のファイル・記述を検出し削除する。

## 前提条件

- プロジェクトが既に初期化済みであること（`scripts/init.sh` が存在しないこと）
- 未初期化の場合は `/init-mcp-server` を先に実行するよう案内して終了する

## 手順

1. **初期化済みか確認する**
   - `scripts/init.sh` が存在する場合 → 未初期化。案内して終了
   - `.claude/skills/init-mcp-server/` が存在する場合 → 未初期化。案内して終了

2. **テンプレート固有の ADR を削除する**
   以下はテンプレートの設計判断であり、初期化後のプロジェクトには不要:
   - `docs/adr/0001-harness-engineering-setup.md`
   - `docs/adr/0002-template-vs-project-values.md`

   ただし以下は**残す**:
   - `docs/adr/0000-template.md` — ADR テンプレート（プロジェクトでも使用する）

3. **CHANGELOG をリセットする**
   テンプレートの初期エントリを削除し、以下の内容に置き換える:
   ```markdown
   # Changelog

   All notable changes to this project will be documented in this file.

   The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
   and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

   ## [Unreleased]
   ```

4. **README からテンプレート固有の記述を削除する**
   `README.md` と `README.ja.md` の両方で:
   - Features セクションの "Harness engineering" / "ハーネスエンジニアリング" 行を削除
   - "harness engineering best practices" / "ハーネスエンジニアリングのベストプラクティスを組み込み済み" を汎用的な記述に変更:
     - EN: "server template with quality engineering best practices."
     - JA: "サーバーテンプレート。品質エンジニアリングのベストプラクティスを組み込み済み。"

5. **`/clean-template` スキル自身を削除する**
   ```bash
   rm -rf .claude/skills/clean-template
   ```

6. **検証する**
   - `grep -ri harness` でテンプレート固有の参照が残っていないか確認
   - 残っている場合はユーザーに報告し、削除するか確認する

7. **結果を報告する**
   削除・変更したファイルの一覧を表示する
