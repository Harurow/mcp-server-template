# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Initial MCP server template with harness engineering setup
- Oxlint + Biome linter/formatter configuration
- Lefthook pre-commit hooks (lint + typecheck + test + coverage)
- Claude Code hooks (PostToolUse auto-format, PreToolUse config protection, Stop test gate)
- Vitest test infrastructure with InMemoryTransport and coverage thresholds (80%)
- ADR template and initial ADR (0001-harness-engineering-setup)
- GitHub Actions CI pipeline (lint + format + typecheck + test with coverage + build)
- Branch protection setup script
- Commit rules and branch rules (`.claude/rules/`)
- `/init-mcp-server` skill for project initialization
- README in English and Japanese with mutual links
- CONTRIBUTING.md with branch strategy, commit rules, and quality gates
- CHANGELOG.md, LICENSE (MIT), PR template, issue templates
- Sample `greet` tool with tests

## [0.1.0] - YYYY-MM-DD

### Added

- First release

[Unreleased]: https://github.com/USER/REPO/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/USER/REPO/releases/tag/v0.1.0
