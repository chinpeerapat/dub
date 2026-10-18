const {
  defineConfig,
} = require("../../apps/web/node_modules/@playwright/test");

module.exports = defineConfig({
  testDir: __dirname,
  testMatch: "browser.spec.cjs",
  workers: 1,
  retries: 0,
  timeout: 60000,
  reporter: "list",
  outputDir: "/tmp/dub-selfhost-browser",
  use: {
    baseURL: "http://localhost:8888",
    headless: true,
    screenshot: "only-on-failure",
  },
});
