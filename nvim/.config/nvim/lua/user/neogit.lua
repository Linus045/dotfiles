local status_ok, neogit = pcall(require, "neogit")
if not status_ok then
  vim.notify("neogit not found")
  return
end

neogit.setup {}
