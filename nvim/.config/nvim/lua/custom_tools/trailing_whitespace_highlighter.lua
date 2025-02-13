local M = {}

M.enabled = false

-- set to true to disable highlighting of trailing whitespace for specific filetypes
M.disabled_filetypes = {
	[""] = true,
	diff = true,
	git = true,
	TelescopePrompt = true,
	TelescopeResults = true,
}

M.setup = function()
	-- vim.api.nvim_create_autocmd({ "BufEnter" }, {
	-- 	group = vim.api.nvim_create_augroup("highlight_trailing_whitespace", { clear = true }),
	-- 	match = "HIGHLIGHT_SPACES"
	-- })

	-- highlight trailing whitespace
	vim.cmd [[highlight HIGHLIGHT_TRAILING_SPACES ctermbg=red guibg=red guifg=red]]

	vim.api.nvim_create_autocmd({ "BufEnter", "FileType" }, {
		pattern = "*",
		group = vim.api.nvim_create_augroup("highlight_trailing_whitespace", { clear = true }),
		callback = M.highlightTrailingWhitespace
	})

	vim.api.nvim_create_user_command("ToggleHighlightTrailingWhitespace", function()
		M.toggleHighlightTrailingWhiteSpace()
	end, {})
end

M.toggleHighlightTrailingWhiteSpace = function()
	M.enabled = not M.enabled
	M.highlightTrailingWhitespace()
end

M.enableHighlightTrailingWhiteSpace = function()
	M.enabled = true
	M.highlightTrailingWhitespace()
end

M.disableHighlightTrailingWhiteSpace = function()
	M.enabled = false
	M.highlightTrailingWhitespace()
end

M.highlightTrailingWhitespace = function()
	local ft = vim.api.nvim_buf_get_option(0, "filetype")

	if M.disabled_filetypes[ft] == true then
		return
	end

	if M.enabled then
		vim.cmd [[match HIGHLIGHT_TRAILING_SPACES /\s\+$/]]
	else
		vim.cmd [[match HIGHLIGHT_TRAILING_SPACES //]]
	end
end

return M
