local colorscheme = nil
-- colorscheme = "catppuccin"
-- colorscheme = "tender"
-- colorscheme = "onedark"
colorscheme = "gruvbox-material"

if colorscheme == "gruvbox-material" then
  vim.g.gruvbox_material_background = "dark"
  vim.g.gruvbox_material_palette = "mix"
end

if colorscheme == "tender" then
  -- Enables 24-bit color (needed for the 'tender' theme)
  vim.opt.termguicolors = true
end

-- NOTE: This is buggy and I don't know how to fix it
if colorscheme == "onedark" then
  vim.cmd("let $NVIM_TUI_ENABLE_TRUE_COLOR=1")
  vim.g.onedark_termcolors = 256
end

-- enable this by default
vim.opt.termguicolors = true

local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
  vim.notify("colorscheme " .. colorscheme .. " not found!")
  return
end
