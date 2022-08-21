local status_ok, trouble = pcall(require, "trouble")
if not status_ok then
  vim.notify("trouble.nvim not found.")
  return
end

trouble.setup {
  position = "right", -- position of the list can be: bottom, top, left, right
}
