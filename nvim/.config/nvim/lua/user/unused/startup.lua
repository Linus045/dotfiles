local status_ok, startup = pcall(require, "startup")
if not status_ok then
  vim.notify("startup not found")
  return
end

startup.setup({
  theme = "dashboard"
})
