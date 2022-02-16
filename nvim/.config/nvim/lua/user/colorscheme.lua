local colorscheme = "tender"
-- colorscheme = "catppuccin"
--colorscheme = "onedark"

local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
  vim.notify("colorscheme " .. colorscheme .. " not found!")
  return
end

-- hightlight keywods to test todo plugin
-- TODO:
-- BUG:
-- HACK:
-- BUG:
-- PERF:
-- NOTE:
-- WARNING:

if colorscheme == "tender" then
  -- Enables 24-bit color (needed for the 'tender' theme)
  vim.opt.termguicolors = true
end

-- NOTE: This is buggy and I don't know how to fix it
if colorscheme == "onedark" then
  vim.cmd "let $NVIM_TUI_ENABLE_TRUE_COLOR=1"
  vim.opt.termguicolors = true
  vim.cmd "let g:onedark_termcolors=256"
end

