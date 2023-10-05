local M = {}

M.disabled = false
M.disabled_filetypes = {}

M.format = function()
	local lspDisabled = M.disabled or M.disabled_filetypes[vim.bo.filetype] or
		vim.b.format_saving
	if lspDisabled then
		return
	end
	vim.lsp.buf.format {
		filter = function(client)
			if client.name == "jsonls" then
				return false
			end
			return true
		end
	}
end

M.setup = function()
	local augroup = vim.api.nvim_create_augroup("Formatter", {})

	vim.api.nvim_clear_autocmds {
		group = augroup,
	}

	vim.api.nvim_create_autocmd("BufWritePre", {
		group = augroup,
		desc = "Format on save",
		pattern = "*",
		callback = M.format,
	})

	vim.api.nvim_create_user_command(
		"FormatToggle",
		function()
			M.disabled = not M.disabled
		end,
		{}
	)
	vim.api.nvim_create_user_command(
		"FormatDisable",
		function()
			M.disabled = true
		end,
		{}
	)
	vim.api.nvim_create_user_command(
		"FormatEnable",
		function()
			M.disabled = false
		end,
		{}
	)

	vim.api.nvim_create_user_command(
		"WriteUnformatted",
		function()
			local old = M.disabled
			M.disabled = true
			vim.cmd("w")
			M.disabled = old
		end,
		{}
	)
end

return M
