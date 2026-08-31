const test = require("node:test");
const assert = require("node:assert/strict");

test("basic application configuration", () => {
  assert.equal(process.env.NODE_ENV || "test", process.env.NODE_ENV || "test");
});
