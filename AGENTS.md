# my-mcp-server

MCP server built with Node.js + TypeScript.

## Commands

```bash
npm run build         # tsc
npm run test          # vitest run
npm run test:coverage # vitest run --coverage (threshold: 80%)
npm run lint          # oxlint + biome check
npm run typecheck     # tsc --noEmit
```

## Structure

- `src/tools/` — one file per tool, filename = tool name
- `test/` — vitest tests using InMemoryTransport (`test/helpers.ts` has `createTestContext`)
- `docs/adr/` — Architecture Decision Records (template: `0000-template.md`)
  - Write an ADR when: choosing between alternatives, making a non-obvious design decision, encountering a bug caused by a design choice, or recording context that code alone cannot convey

## Rules

- Zod schema required for all tool inputs
- Named exports only (no default exports)
- No `any` type — use `unknown` + Zod parse
- No `console.log` in src/ (breaks STDIO transport)
- No `eval()`, `new Function()`, template string in `exec()`
- Errors must use McpError, not raw throw
- No deprecated APIs, packages, or features — see `.claude/rules/deprecated-rules.md`

## Documentation Sync

- When adding, changing, or removing features, update related docs in the same PR
  - Targets: README.md, README.ja.md, CLAUDE.md, AGENTS.md, CHANGELOG.md, docs/adr/
- If you find outdated docs, create a PR to fix them — don't leave them stale

## Proactive Improvement

- When you find bugs, inconsistencies, or improvements, create a feature branch and submit a fix PR
- Prefer "small PR now" over "noticed but ignored"
- For larger fixes, create an Issue to track
- If a fix involves a design decision (meets ADR criteria), include the ADR in the same PR

## Commit Rules

- 1 commit = 1 logical change. Do not mix unrelated changes
- Format: `<type>: <description>` (types: feat, fix, chore, docs, refactor, test)
- Before committing: verify diff, check for contradictions, confirm no missing updates, verify doc sync

## Branch Rules

- `main` is protected. Never push directly
- Branch naming: `feat/<name>`, `fix/<name>`, `chore/<name>` (kebab-case)
- Merge via squash merge only. CI must pass + 1 review required
