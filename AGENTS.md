# harness-mcp-server

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

## Rules

- Zod schema required for all tool inputs
- Named exports only (no default exports)
- No `any` type — use `unknown` + Zod parse
- No `console.log` in src/ (breaks STDIO transport)
- No `eval()`, `new Function()`, template string in `exec()`
- Errors must use McpError, not raw throw

## Commit Rules

- 1 commit = 1 logical change. Do not mix unrelated changes
- Format: `<type>: <description>` (types: feat, fix, chore, docs, refactor, test)
- Before committing: verify diff, check for contradictions, confirm no missing updates

## Branch Rules

- `main` is protected. Never push directly
- Branch naming: `feat/<name>`, `fix/<name>`, `chore/<name>` (kebab-case)
- Merge via squash merge only. CI must pass + 1 review required
