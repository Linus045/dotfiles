local M = {}

M.disabled = false
M.disabled_filetypes = {}

M.is_formatting_disabled = function()
	return M.disabled or M.disabled_filetypes[vim.bo.filetype] or
		vim.b.format_saving
end

-- general format function
M.format_function = function()
	M.format_buffer()

	-- also run mhartington/formatter.nvim formatter function
	vim.cmd(":Format")
end

-- only formats the current buffer
M.format_buffer = function()
	vim.lsp.buf.format {
		filter = function(client)
			-- dont format with jsonls
			if client.name == "jsonls" then
				return false
			end
			if client.name == "vtsls" then
				return false
			end
			vim.notify("Formatting with " .. client.name)
			return true
		end
	}
end

M.format_before_save = function()
	if not M.is_formatting_disabled() then
		M.format_buffer()
	end
end


M.format_after_save = function()
	if not M.is_formatting_disabled() then
		-- run mhartington/formatter.nvim formatter function
		vim.cmd(":Format")
	end
end


M.setup = function()
	local augroup = vim.api.nvim_create_augroup("Formatter", {})

	vim.api.nvim_clear_autocmds {
		group = augroup,
	}

	vim.api.nvim_create_autocmd("BufWritePre", {
		group = augroup,
		desc = "Format before save",
		pattern = "*",
		callback = M.format_before_save,
	})

	vim.api.nvim_create_autocmd("BufWritePost", {
		group = augroup,
		desc = "Format after save",
		pattern = "*",
		callback = M.format_after_save,
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

	vim.api.nvim_create_user_command(
		"F",
		function()
			M.format_function()
		end,
		{}
	)
end

return M
