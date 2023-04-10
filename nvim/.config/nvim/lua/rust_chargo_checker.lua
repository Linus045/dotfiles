local M = {}

M.register_rust_cargo_check_autocommand = function()
	-- check if window exists otherwise create it

	M.window_nr = -1
	M.buf_nr = -1

	vim.api.nvim_create_autocmd("BufWritePost", {
		group = vim.api.nvim_create_augroup("rust_cargo_check_autocommand", { clear = true }),
		pattern = "*.rs",
		callback = function()
			-- make sure this is a rust file
			local filetype = vim.api.nvim_buf_get_option(0, "filetype")
			if filetype ~= "rust" then
				return
			end

			if vim.api.nvim_buf_is_valid(M.buf_nr) then
				-- vim.notify("Closed buffer: " .. M.buf_nr)
				vim.api.nvim_buf_delete(M.buf_nr, { force = true, unload = false })
			end

			if vim.api.nvim_win_is_valid(M.window_nr) then
				-- vim.notify("Closed window: " .. M.window_nr)
				vim.api.nvim_win_close(M.window_nr, false)
			end


			local args = { "cargo", "check", "--message-format", "human", "-q", "--color", "always" }
			vim.cmd("noautocmd new | resize 6 | terminal " .. vim.fn.join(args, " "))
			M.buf_nr = vim.api.nvim_get_current_buf()
			local win = vim.api.nvim_get_current_win()
			M.window_nr = win

			-- TODO: Maybe try this with AnsiEsc but for now its fine to call it via :terminal
			--   -- callback to handle 'cargo check' output
			--   local on_cargo_check = function(_, output_lines)
			--     local lines_to_print = {}
			--     local error_amount = 1

			--     -- only include the first error from the output
			--     for lineNr, line in ipairs(output_lines) do
			--       if vim.startswith(line, "error") then
			--         if error_amount == 0 then
			--           break
			--         end

			--         error_amount = error_amount - 1
			--         table.insert(lines_to_print, line)
			--       else
			--         table.insert(lines_to_print, line)
			--       end
			--     end

			--     if #lines_to_print == 0 then
			--       return
			--     end

			--     if not vim.api.nvim_win_is_valid(M.rust_cargo_check_window_nr) then
			--       -- create window
			--       vim.cmd('noautocmd new | terminal')
			--       vim.cmd('resize 6')
			--       local win = vim.api.nvim_get_current_win()
			--       M.rust_cargo_check_window_nr = win
			--     end


			--     -- check if buffer exists, otherwise create it
			--     if not vim.api.nvim_buf_is_valid(M.rust_cargo_check_buf_nr) then
			--       M.rust_cargo_check_buf_nr = vim.api.nvim_create_buf(true, true)
			--       if M.rust_cargo_check_buf_nr == 0 then
			--         print("[Utilities.RustCheck] Failed to create buffer")
			--         return
			--       end
			--     end

			--     -- set buffer for window
			--     -- vim.api.nvim_buf_set_option(M.rust_cargo_check_buf_nr, "buftype", "terminal")
			--     vim.api.nvim_buf_set_lines(M.rust_cargo_check_buf_nr, 0, -1, false, lines_to_print)
			--     vim.api.nvim_win_set_buf(M.rust_cargo_check_window_nr, M.rust_cargo_check_buf_nr)
			--     vim.api.nvim_buf_set_option(M.rust_cargo_check_buf_nr, "bt", "terminal")
			--     -- vim.api.nvim_buf_set_option(M.rust_cargo_check_buf_nr, "readonly", true)
			--   end

			--   print("Running cargo check")
			--   -- message-format human|short|json|json-diagnostic-short|json-diagnostic-rendered-ansi|json-render-diagnostics
			--   local args = { "cargo", "check", "--message-format", "human", "-q", "--color", "always" }
			--   vim.fn.jobstart(args, {
			--     stdout_buffered = true,
			--     stderr_buffered = true,
			--     on_stdout = on_cargo_check,
			--     on_stderr = on_cargo_check,
			--   })
		end
	})
end

return M
