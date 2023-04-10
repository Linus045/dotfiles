local M = {}

M.in_debug_session = false

M.setup = function()
	vim.cmd("packadd termdebug")

	vim.api.nvim_create_autocmd({ "User" }, {
		pattern = "TermdebugStartPost",
		callback = function()
			M.in_debug_session = true
		end
	})

	vim.api.nvim_create_autocmd({ "User" }, {
		pattern = "TermdebugStopPost",
		callback = function()
			M.in_debug_session = false
		end
	})
end


return M
