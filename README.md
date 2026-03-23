# mcp-server-template

[![CI](https://github.com/Harurow/mcp-server-template/actions/workflows/ci.yml/badge.svg)](https://github.com/Harurow/mcp-server-template/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

[Model Context Protocol (MCP)](https://modelcontextprotocol.io) server template with harness engineering best practices.

**[日本語版はこちら / Japanese](README.ja.md)**

## Features

- **TypeScript + strict mode** — `noUncheckedIndexedAccess`, `NodeNext` module resolution
- **Harness engineering** — PostToolUse hooks, pre-commit gates, CI quality checks
- **Linting** — [Oxlint](https://oxc.rs/docs/guide/usage/linter) (lint) + [Biome](https://biomejs.dev) (format), Rust-powered for millisecond feedback
- **Testing** — [Vitest](https://vitest.dev) with MCP SDK `InMemoryTransport` for protocol-level tests
- **Pre-commit** — [Lefthook](https://github.com/evilmartians/lefthook) enforces lint + typecheck + test + coverage on every commit

## Installation

### Run directly with npx (no install)

```bash
npx harness-mcp-server
```

### Install globally with npm

```bash
npm install -g harness-mcp-server
harness-mcp-server
```

### Clone from repository

```bash
git clone https://github.com/USER/REPO.git
cd REPO
npm install
npm run build
npm run start
```

<!-- TEMPLATE_START -->
## Using as a Template

### From GitHub (recommended)

1. Create a new repository from this template:
   ```bash
   gh repo create my-new-mcp --template harurow/mcp-server-template --clone --private
   cd my-new-mcp
   ```

2. Run the init script to customize the project:
   ```bash
   bash scripts/init.sh my-new-mcp
   ```

3. Set up branch protection (optional):
   ```bash
   gh repo create my-new-mcp --private --source=. --push  # if not pushed yet
   bash scripts/setup-branch-protection.sh
   ```

### With Claude Code

```bash
/init-mcp-server my-new-mcp
```

### Manual copy

```bash
cp -r /path/to/mcp-server-template ~/code/my-new-mcp
cd ~/code/my-new-mcp
bash scripts/init.sh my-new-mcp
```

> After initialization, `scripts/init.sh` is deleted and this section is removed from the README.
<!-- TEMPLATE_END -->

## Development

```bash
npm run dev          # Start dev server (tsx watch)
npm run inspect      # Open MCP Inspector
npm run test         # Run tests
npm run test:coverage # Run tests with coverage (threshold: 80%)
npm run test:watch   # Run tests in watch mode
npm run lint         # Run oxlint + biome
npm run typecheck    # Run tsc --noEmit
npm run build        # Build to dist/
```

## Adding a Tool

1. Create `src/tools/<name>.ts`:

```typescript
import type { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { z } from "zod";

export function registerMyTool(server: McpServer): void {
  server.tool(
    "my-tool",
    "Description of what this tool does",
    {
      param: z.string().describe("Parameter description"),
    },
    async ({ param }) => {
      return {
        content: [{ type: "text", text: `Result: ${param}` }],
      };
    },
  );
}
```

2. Register in `src/server.ts`:

```typescript
import { registerMyTool } from "./tools/my-tool.js";
registerMyTool(server);
```

3. Add test in `test/<name>.test.ts`:

```typescript
import { afterEach, describe, expect, it } from "vitest";
import type { TestContext } from "./helpers.js";
import { createTestContext } from "./helpers.js";

describe("my-tool", () => {
  let ctx: TestContext;
  afterEach(async () => { await ctx.cleanup(); });

  it("returns expected result", async () => {
    ctx = await createTestContext();
    const result = await ctx.client.callTool({
      name: "my-tool",
      arguments: { param: "hello" },
    });
    expect(result.content).toEqual([{ type: "text", text: "Result: hello" }]);
  });
});
```

## MCP Client Configuration

Add to your MCP client config (e.g. Claude Desktop):

```json
{
  "mcpServers": {
    "harness-mcp-server": {
      "command": "npx",
      "args": ["-y", "harness-mcp-server"]
    }
  }
}
```

Or if installed globally or cloned locally:

```json
{
  "mcpServers": {
    "harness-mcp-server": {
      "command": "node",
      "args": ["/absolute/path/to/dist/index.js"]
    }
  }
}
```

## Project Structure

```
src/
├── index.ts               # STDIO entrypoint
├── server.ts              # McpServer creation + tool registration
└── tools/                 # One file per tool (filename = tool name)
test/
├── helpers.ts             # Shared test utilities (createTestContext)
└── *.test.ts              # Tests using InMemoryTransport
docs/adr/                  # Architecture Decision Records
scripts/                   # init.sh, setup-branch-protection.sh
.claude/                   # Hooks, settings, rules, skills
.github/workflows/         # CI pipeline
biome.json                 # Formatter config (Biome)
lefthook.yml               # Pre-commit hooks
tsconfig.json              # TypeScript config (strict)
vitest.config.ts           # Test config + coverage thresholds
```

> **Note**: `package.json` has `"private": true` by default. Remove it before publishing to npm.

## Branch Strategy

- `main` — protected, requires CI pass + PR review to merge
- `feat/<name>` — feature branches, squash-merged into main
- `fix/<name>` — bugfix branches
- `chore/<name>` — maintenance (deps, CI, docs)

See [CONTRIBUTING.md](CONTRIBUTING.md) for details.

## License

[MIT](LICENSE)
