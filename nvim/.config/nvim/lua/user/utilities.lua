local ThemeManager = require("utils.nvim.theme.theme-manager")
local HighlightGroups = require("utils.nvim.highlighting.highlight-groups")
local highlighter = require("utils.nvim.highlighting.highlighter")

local theme = ThemeManager.get_theme()

local highlight_groups = HighlightGroups({
	TextYank = { guibg = theme.normal.yellow, guifg = theme.normal.black },
})

highlighter:new():add(highlight_groups):register_highlights()

vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
	pattern = { "*.c", "*.h", "*.cpp" },
	callback = function()
		vim.api.nvim_buf_set_option(0, "tabstop", 4)
		vim.api.nvim_buf_set_option(0, "shiftwidth", 4)
	end
})
