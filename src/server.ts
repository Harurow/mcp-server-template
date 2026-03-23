import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { registerGreetTool } from "./tools/greet.js";

export function createServer(): McpServer {
	const server = new McpServer({
		name: "my-mcp-server",
		version: "0.1.0",
	});

	registerGreetTool(server);

	return server;
}
