import type { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { z } from "zod";

export function registerGreetTool(server: McpServer): void {
  server.tool(
    "greet",
    "Greet a user by name",
    {
      name: z.string().min(1).describe("Name of the person to greet"),
    },
    async ({ name }) => {
      return {
        content: [{ type: "text", text: `Hello, ${name}!` }],
      };
    },
  );
}
