import { afterEach, describe, expect, it } from "vitest";
import type { TestContext } from "./helpers.js";
import { createTestContext } from "./helpers.js";

describe("greet tool", () => {
	let ctx: TestContext;

	afterEach(async () => {
		await ctx.cleanup();
	});

	it("returns greeting with name", async () => {
		ctx = await createTestContext();
		const result = await ctx.client.callTool({ name: "greet", arguments: { name: "World" } });
		expect(result.content).toEqual([{ type: "text", text: "Hello, World!" }]);
	});

	it("is listed in available tools", async () => {
		ctx = await createTestContext();
		const { tools } = await ctx.client.listTools();
		const greet = tools.find((t) => t.name === "greet");
		expect(greet).toBeDefined();
		expect(greet?.description).toBe("Greet a user by name");
	});

	it("rejects empty name", async () => {
		ctx = await createTestContext();
		const result = await ctx.client.callTool({ name: "greet", arguments: { name: "" } });
		expect(result.isError).toBe(true);
	});
});
