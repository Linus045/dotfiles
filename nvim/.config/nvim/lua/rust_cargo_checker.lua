local M = {}

M.setup = function()
	vim.api.nvim_create_user_command('CargoCheckEnable', function()
			M.enabled = true
		end,
		{})

	vim.api.nvim_create_user_command('CargoCheckDisable', function()
			M.enabled = false
			M.close_window()
		end,
		{})

	vim.api.nvim_create_user_command('CargoCheckToggle', function()
			M.enabled = not M.enabled
			if not M.enabled then
				M.close_window()
			end
		end,
		{})

	M.cmd_output_changed_group = vim.api.nvim_create_augroup("rust_cargo_check_autocommand_output_changed",
		{ clear = true })
end

M.window_nr = -1
M.buf_nr = -1

M.enabled = true


M.current_buffer_filetype_is_rust = function()
	local filetype = vim.api.nvim_buf_get_option(0, "filetype")
	return filetype == "rust"
end

M.close_window = function()
	if M.window_nr ~= -1 then
		vim.api.nvim_win_close(M.window_nr, true)
		M.window_nr = -1
	end
end

M.window_height = 10

M.create_window = function(use_window)
	if use_window == nil then
		use_window = true
	end

	if use_window then
		local lines = vim.api.nvim_get_option("lines")
		local columns = vim.api.nvim_get_option("columns")
		local width = math.floor(columns / 2) - 5
		local winId = vim.api.nvim_open_win(0, false,
			{
				relative = 'win',
				anchor = 'SE',
				row = lines - 5,
				col = columns - 1,
				width = width,
				height = 30, -- gets updated later to reduce flickering
				style = 'minimal',
				border = 'rounded',
			}
		)
		if winId == 0 then
			vim.notify("Unable to create window")
			return
		end
		M.window_nr = winId
	else
		-- create split
		vim.cmd("split")
		M.window_nr = vim.api.nvim_get_current_win()
	end

	-- vim.api.nvim_win_set_option(winId, "number", false)
	-- vim.api.nvim_win_set_option(winId, "relativenumber", false)
	-- vim.api.nvim_win_set_option(winId, "cursorline", false)
	-- vim.api.nvim_win_set_option(winId, "spell", false)
	-- vim.api.nvim_win_set_option(winId, "colorcolumn", "")
	-- vim.api.nvim_buf_set_option(winId, "spell", false)
end

M.get_error_warning_count = function()
	print("Cargo check...")
	vim.cmd("make! check")
	vim.cmd("redraw!")

	local qflist = vim.fn.getqflist()
	local error_count = 0
	local warning_count = 0
	if #qflist > 0 then
		-- Check for type W
		-- Ignore everything until we get an E
		local collect_err = 0
		local new_qf_list = {}
		for k, v in pairs(qflist) do
			-- Count number of warnings
			if v.type == "W" and v.text ~= ".*generated\\s\\d*\\swarning" then
				-- if v.type == "W"
				warning_count = warning_count + 1
				collect_err = 0
			end

			-- Count errors
			if v.type == "E" then
				collect_err = 1
				error_count = error_count + 1
			end

			-- Add errors to the new quickfix list
			if collect_err then
				new_qf_list[#new_qf_list + 1] = v
			end
		end

		vim.fn.setqflist(new_qf_list)
	end

	return { ["error_count"] = error_count, ["warning_count"] = warning_count, ["quickfix_list"] = qflist }
end


M.print_error_warning_count = function(error_count, warning_count)
	local err_out = "echo 'E: " .. error_count .. "'"
	if error_count > 0 then
		err_out = "echohl ToggleRustErr | echo 'E: " .. error_count .. "' | echohl None"
	end

	local warn_out = " | echon ' | W: " .. warning_count .. "'"
	if warning_count > 0 then
		warn_out = "| echon ' | ' | echohl ToggleRustWarn | echon 'W: " .. warning_count .. "' | echohl None"
	end

	if error_count == 0 and warning_count == 0 then
		err_out = "echo '- No errors/warnings 💖 -'"
		warn_out = ''
	end
	vim.cmd(err_out .. warn_out)
end


M.register_rust_cargo_check_autocommand = function()
	local use_window = false


	vim.api.nvim_create_autocmd("BufWritePost", {
		group = vim.api.nvim_create_augroup("rust_cargo_check_autocommand", { clear = true }),
		pattern = "*.rs",
		callback = function()
			-- make sure this is a rust file
			local filetype = vim.api.nvim_buf_get_option(0, "filetype")
			if filetype ~= "rust" then
				return
			end

			-- make sure that cargo is set as the makeprg
			vim.api.nvim_buf_set_option(0, "makeprg", "cargo")

			if vim.api.nvim_buf_is_valid(M.buf_nr) then
				vim.api.nvim_buf_delete(M.buf_nr, { force = true, unload = false })
			end

			if not M.enabled then
				return
			end

			M.create_window(use_window)

			local oldwin = vim.api.nvim_get_current_win()
			vim.api.nvim_set_current_win(M.window_nr)
			vim.api.nvim_win_set_option(0, "spell", false)
			-- local buf = vim.api.nvim_create_buf(false, true)
			-- M.rust_cargo_check_buf_nr = buf

			-- vim.api.nvim_win_set_buf(M.window_nr, buf)
			-- vim.cmd("AnsiEsc")
			-- vim.api.nvim_set_current_win(oldwin)

			-- local args = { "cargo", "check", "--message-format", "human", "-q", "--color", "always" }
			local args = { "cargo", "clippy", "--message-format", "human", "--color",
				"always", --[[ "--", "-Dwarnings" ]] }
			vim.cmd("terminal " .. vim.fn.join(args, " "))
			M.buf_nr = vim.api.nvim_get_current_buf()
			vim.api.nvim_buf_set_option(M.buf_nr, "modifiable", true)
			vim.api.nvim_set_current_win(oldwin)


			vim.api.nvim_create_autocmd("TermClose", {
				group = M.cmd_output_changed_group,
				buffer = M.buf_nr,
				callback = function(opts)
					local exit_status = vim.v.event.status
					-- retrieve the error and warning count before switching the window

					local oldwin = vim.api.nvim_get_current_win()

					local error_warnings = M.get_error_warning_count()
					if (exit_status == 0) and (error_warnings.warning_count == 0) then
						local height = 1
						-- delete old buffer
						vim.cmd("bwipe " .. M.buf_nr)

						-- create a new window and set "No errors found." text there
						-- M.create_window(use_window)
						-- vim.api.nvim_set_current_win(M.window_nr)
						-- M.buf_nr = vim.api.nvim_create_buf(false, true)
						-- vim.api.nvim_win_set_buf(M.window_nr, M.buf_nr)
						-- vim.api.nvim_buf_set_option(M.buf_nr, "modifiable", true)
						-- vim.cmd("resize " .. height)
						-- vim.api.nvim_buf_set_lines(M.buf_nr, 0, -1, false, { "No errors found." })
						-- vim.api.nvim_buf_set_option(M.buf_nr, "modifiable", false)
					else
						vim.api.nvim_set_current_win(M.window_nr)
						vim.api.nvim_win_set_buf(M.window_nr, M.buf_nr)

						vim.api.nvim_buf_set_option(M.buf_nr, "modifiable", true)
						vim.cmd("resize " .. M.window_height)
						vim.api.nvim_buf_set_option(M.buf_nr, "modifiable", false)
					end
					vim.api.nvim_set_current_win(oldwin)

					if error_warnings.error_count > 0 then
						vim.fn.setqflist(error_warnings.quickfix_list)
						-- vim.cmd("cfirst")
					end
					M.print_error_warning_count(error_warnings.error_count, error_warnings.warning_count)
				end,
			})


			-- local on_cargo_check = function(_, output_lines)
			-- 	local lines_to_print = {}
			-- 	-- how many errors to list
			-- 	local error_amount = 1

			-- 	-- only include the first error from the output
			-- 	for lineNr, line in ipairs(output_lines) do
			-- 		local results = string.find(line, "error")
			-- 		if results ~= nil then
			-- 			if error_amount == 0 then
			-- 				break
			-- 			end

			-- 			error_amount = error_amount - 1
			-- 			table.insert(lines_to_print, line)
			-- 		else.
			-- 			-- table.insert(lines_to_print, line)
			-- 		end
			-- 	end

			-- 	if #lines_to_print == 0 then
			-- 		lines_to_print = { "No errors found" }
			-- 		local oldwin = vim.api.nvim_get_current_win()
			-- 		vim.api.nvim_set_current_win(winId)
			-- 		vim.cmd("resize 4")
			-- 		vim.api.nvim_set_current_win(oldwin)
			-- 	else
			-- 		vim.api.nvim_set_current_win(winId)
			-- 		vim.cmd("resize " .. (#lines_to_print + 4))
			-- 		vim.api.nvim_set_current_win(oldwin)
			-- 	end

			-- 	-- set buffer for window
			-- 	-- vim.api.nvim_buf_set_option(M.rust_cargo_check_buf_nr, "buftype", "terminal")
			-- 	vim.api.nvim_buf_set_option(M.rust_cargo_check_buf_nr, "modifiable", true)
			-- 	vim.api.nvim_buf_set_lines(M.rust_cargo_check_buf_nr, 0, -1, false, lines_to_print)
			-- 	vim.api.nvim_buf_set_option(M.rust_cargo_check_buf_nr, "modifiable", false)
			-- 	-- vim.api.nvim_buf_set_option(M.rust_cargo_check_buf_nr, "bt", "terminal")
			-- 	-- vim.api.nvim_buf_set_option(M.rust_cargo_check_buf_nr, "readonly", true)
			-- end

			-- local args = { "cargo", "check", "--message-format", "human", "-q", "--color", "always" }
			-- vim.fn.jobstart(args, {
			-- 	stdout_buffered = true,
			-- 	stderr_buffered = true,
			-- 	on_stdout = on_cargo_check,
			-- 	on_stderr = on_cargo_check,
			-- })
		end
	})
end

return M
