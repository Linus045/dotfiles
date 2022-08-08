local ThemeManager = require("utils.nvim.theme.theme-manager")
local HighlightGroups = require("utils.nvim.highlighting.highlight-groups")
local highlighter = require("utils.nvim.highlighting.highlighter")

local theme = ThemeManager.get_theme()

local highlight_groups = HighlightGroups({
	TextYank = { guibg = theme.normal.yellow, guifg = theme.normal.black },
})

highlighter:new():add(highlight_groups):register_highlights()

vim.cmd("autocmd TextYankPost * silent! lua vim.highlight.on_yank {higroup=(vim.fn['hlexists']('HighlightedyankRegion') > 0 and 'HighlightedyankRegion' or 'IncSearch'), timeout=300}")


function P(v)
  print(vim.inspect(v))
  return v
end
