const {
  test,
  expect,
} = require("../../apps/web/node_modules/@playwright/test");

test("sign in through the browser and view the persisted short link", async ({
  page,
}) => {
  const errors = [];
  page.on("pageerror", (error) => errors.push(error.message));
  await page.goto("/login?next=/selfhost-smoke/links");
  await page.locator('input[name="email"]').fill("selfhost-smoke@example.test");
  await page.getByTestId("auth-login-submit").click();
  const password = page.locator('input[type="password"]');
  await expect(password).toBeVisible();
  await password.fill("SelfhostTest-2026!");
  await page.getByTestId("auth-login-submit").click();
  await page.waitForURL("**/selfhost-smoke/links", {
    waitUntil: "domcontentloaded",
  });
  await expect(
    page.getByText("docker-smoke", { exact: false }).first(),
  ).toBeVisible({ timeout: 30000 });
  expect(errors).toEqual([]);
});
