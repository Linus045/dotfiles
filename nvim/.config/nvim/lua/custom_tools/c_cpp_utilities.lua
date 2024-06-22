local M = {}


M.RunCurrentCFile = function(argsString)
	-- make sure this is a c file
	local filetype = vim.api.nvim_buf_get_option(0, "filetype")
	if filetype ~= "c" then
		return
	end

	if M.buf_nr and vim.api.nvim_buf_is_valid(M.buf_nr) then
		-- vim.notify("Closed buffer: " .. M.buf_nr)
		vim.api.nvim_buf_delete(M.buf_nr, { force = true, unload = false })
	end

	if M.window_nr and vim.api.nvim_win_is_valid(M.window_nr) then
		-- vim.notify("Closed window: " .. M.window_nr)
		vim.api.nvim_win_close(M.window_nr, false)
	end

	local runArgs = {}
	if argsString ~= nil then
		runArgs = vim.fn.split(argsString, " ", false)
	end
	local file = vim.api.nvim_buf_get_name(0)
	local args = { "gcc", "-g", "-Wall", file, "-o", "/tmp/nvim_c_program", "&&", "/tmp/nvim_c_program" }
	args = vim.fn.extend(args, runArgs)
	vim.cmd("noautocmd new | resize 6 | terminal " .. vim.fn.join(args, " "))
	M.buf_nr = vim.api.nvim_get_current_buf()
	local win = vim.api.nvim_get_current_win()
	M.window_nr = win
end

M.register_gcc_run_user_command = function()
	vim.api.nvim_create_user_command("RunCFile", function(opts)
		M.RunCurrentCFile(opts.args)
	end, { nargs = "*" })
end

M.register_gcc_check_autocommand = function()
	-- check if window exists otherwise create it

	M.window_nr = -1
	M.buf_nr = -1

	vim.api.nvim_create_autocmd("BufWritePost", {
		group = vim.api.nvim_create_augroup("gcc_check_autocommand", { clear = true }),
		callback = function(_opts)
			M.RunCurrentCFile()
		end
	})
end

return M
