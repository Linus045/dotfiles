local status_ok, catppuccin = pcall(require, "catppuccin")
if not status_ok then
  vim.notify("catppuccin not found")
  return
end
catppuccin.setup {}