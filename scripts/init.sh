#!/usr/bin/env bash
set -euo pipefail

# MCP Server テンプレート初期化スクリプト
# Usage: bash scripts/init.sh <server-name> [github-owner]
# Example: bash scripts/init.sh my-awesome-mcp harurow

if [ $# -lt 1 ]; then
  echo "Usage: bash scripts/init.sh <server-name> [github-owner]"
  echo "Example: bash scripts/init.sh my-awesome-mcp harurow"
  exit 1
fi

NAME="$1"
OWNER="${2:-}"

if ! echo "$NAME" | grep -qE '^[a-z][a-z0-9-]*$'; then
  echo "Error: server name must be kebab-case (e.g., my-awesome-mcp)"
  exit 1
fi

# Auto-detect GitHub owner if not specified
if [ -z "$OWNER" ]; then
  OWNER="$(gh api user -q '.login' 2>/dev/null || echo 'USER')"
fi

REPO_SLUG="$OWNER/$NAME"
echo "Initializing MCP server: $NAME (GitHub: $REPO_SLUG)"

# Cross-platform sed in-place (macOS vs Linux)
sedi() {
  if sed --version 2>/dev/null | grep -q GNU; then
    sed -i "$@"
  else
    sed -i '' "$@"
  fi
}

# Replace project name in all relevant files
for f in package.json src/server.ts CLAUDE.md AGENTS.md README.md README.ja.md CHANGELOG.md .env.example; do
  [ -f "$f" ] && sedi "s/my-mcp-server/$NAME/g" "$f"
done

# Replace template repo references with new project
for f in README.md README.ja.md; do
  [ -f "$f" ] && sedi "s|# mcp-server-template|# $NAME|g" "$f"
  [ -f "$f" ] && sedi "s|Harurow/mcp-server-template|$REPO_SLUG|g" "$f"
  [ -f "$f" ] && sedi "s|cd REPO|cd $NAME|g" "$f"
done

# Replace remaining USER/REPO placeholders (CHANGELOG etc.)
for f in CHANGELOG.md; do
  [ -f "$f" ] && sedi "s|USER/REPO|$REPO_SLUG|g" "$f"
done

# Replace LICENSE copyright holder
[ -f LICENSE ] && sedi "s/harurow/$OWNER/g" LICENSE

# Remove template sections from READMEs
for f in README.md README.ja.md; do
  [ -f "$f" ] && sedi '/<!-- TEMPLATE_START -->/,/<!-- TEMPLATE_END -->/d' "$f"
done

# Remove sample tool
rm -f src/tools/greet.ts test/greet.test.ts

# Reset server.ts to empty registration
cat > src/server.ts << SERVEREOF
import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";

export function createServer(): McpServer {
	const server = new McpServer({
		name: "$NAME",
		version: "0.1.0",
	});

	// Register tools here:
	// import { registerXxxTool } from "./tools/xxx.js";
	// registerXxxTool(server);

	return server;
}
SERVEREOF

# Remove template-only files (no longer needed after initialization)
rm -f scripts/init.sh
rm -rf .claude/skills/init-mcp-server
# Keep setup-branch-protection.sh

# Install & setup first (so lefthook is available for git commit)
rm -rf .git
git init
npm install
npx lefthook install

# Initial commit (with lefthook pre-commit active)
git add -A
git commit -m "Initial commit from mcp-server template" --no-verify
# Note: --no-verify used only for initial commit since there are no test files yet

echo ""
echo "Done! Next steps:"
echo "  1. Add tools in src/tools/"
echo "  2. Register them in src/server.ts"
echo "  3. Add tests in test/"
echo "  4. npm run dev       — start dev server"
echo "  5. npm run inspect   — test with MCP Inspector"
echo ""
echo "GitHub setup:"
echo "  gh repo create $NAME --private --source=. --push"
echo "  bash scripts/setup-branch-protection.sh"
