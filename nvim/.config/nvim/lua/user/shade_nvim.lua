local status_ok, shade = pcall(require, 'shade')
if not status_ok then
  vim.notify("shade.nvim not found")
  return
end

shade.setup({
  debug = false,
  overlay_opacity = 70,
  opacity_step = 1,
  keys = {
    -- brightness_up    = '<C-Up>',
    -- brightness_down  = '<C-Down>',
    -- toggle           = '<Leader>s',
  }
})
