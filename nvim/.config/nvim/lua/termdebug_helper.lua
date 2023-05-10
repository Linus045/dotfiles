local M = {}

M.in_debug_session = false

M.setup = function()
	vim.cmd("packadd termdebug")

	vim.api.nvim_create_autocmd({ "User" }, {
		pattern = "TermdebugStartPost",
		callback = function(e)
			M.in_debug_session = true
			M.debugger_buf_id = e.buf
		end
	})

	vim.api.nvim_create_autocmd({ "User" }, {
		pattern = "TermdebugStopPost",
		callback = function()
			M.in_debug_session = false
			M.debugger_buf_id = -1
		end
	})

	M.setup2()
end

--------------------------------------------------------------------------------------------------
-- Code below is sourced from:                                                                  --
-- https://github.com/togglebyte/togglerust/blob/main/ftplugin/rust.vim                         --
-- it was then edited and converted to lua by me                                                --
--------------------------------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
--     - Highlight groups -
-- -----------------------------------------------------------------------------
M.setup2 = function()
	vim.cmd("highlight ToggleRustErr ctermbg=0 ctermfg=1")
	vim.cmd("highlight ToggleRustWarn ctermbg=0 ctermfg=3")

	vim.api.nvim_create_user_command("RustCompile", M.CompileSomeRust, {})

	vim.api.nvim_create_user_command("RustDebugKill", M.KillDebugger, {})
	vim.api.nvim_create_user_command("RustDebugTest", M.RunDebugger, {})
	vim.api.nvim_create_user_command("RustDebugMain", M.RunDebuggerFromMain, {})
	vim.api.nvim_create_user_command("RustDebugAndBreak", M.RunDebugAndBreak, {})
end

-- -----------------------------------------------------------------------------
--     - Rust help -
-- -----------------------------------------------------------------------------
-- function! RustDocs()
--     let l:word = expand("<cword>")
--     :call RustMan(word)
-- end

-- function! RustMan(word)
--     if has('nvim')
--         let l:command  = ':term rusty-man ' . a:word
--     else
--         let l:command  = ':term ++close rusty-man ' . a:word
--     endif

--     execute command
-- end

-- :command! -nargs=1 Rman call RustMan(<f-args>)

-- -----------------------------------------------------------------------------
--     - Compiling -
-- -----------------------------------------------------------------------------
M.CompileSomeRust = function()
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

	-- If we have errors then open the quickfix window
	-- otherwise display the number of warnings
	if error_count > 0 then
		if vim.fn.tabpagewinnr(vim.fn.tabpagenr(), '$') > 1 then
			vim.cmd("botright copen 6")
		else
			vim.cmd("copen 6")
		end
		vim.cmd("wincmd p")
		vim.cmd("cfirst")
	else
		vim.cmd("cclose")
	end

	local err_out = "echo 'E: " .. error_count .. "'"
	if error_count > 0 then
		err_out = "echohl ToggleRustErr | echo 'E: " .. error_count .. "' | echohl None"
	end

	local warn_out = " | echon ' | W: " .. warning_count .. "'"
	if warning_count > 0 then
		warn_out = "| echon ' | ' | echohl ToggleRustWarn | echon 'W: " .. warning_count .. "' | echohl None"
	end
	-- if l:error_count == 0 && l:warning_count == 0
	--     local err_out = "print("- 💖 -'")
	--     local warn_out = ''
	-- end

	vim.cmd(err_out .. warn_out)
end

-- -----------------------------------------------------------------------------
--     - Debug stuff -
-- -----------------------------------------------------------------------------

-- Find rust function name
-- Taken from rust.vim (https://github.com/rust-lang/rust.vim)
M.FindTestFunctionNameUnderCursor = function()
	local cursor_line = vim.fn.line('.')

	-- Find #[test] attribute
	if vim.fn.search("\\m\\C^#\\[test\\]", "bcW") == 0 then
		return ''
	end

	-- Move to an opening brace of the test function
	local test_func_line = vim.fn.search('\\m\\C^\\s*fn\\s\\+\\h\\w*\\s*(.\\+{$', 'eW')
	if test_func_line == 0 then
		return ''
	end

	-- Search the end of test function (closing brace) to ensure that the
	-- cursor position is within function definition
	vim.cmd("normal! %")
	if vim.fn.line('.') < cursor_line then
		return ''
	end
	return vim.fn.matchstr(vim.fn.getline(test_func_line), '\\m\\C^\\s*fn\\s\\+\\zs\\h\\w*')
end

M.FindTestExecutable = function(test_func_name)
	local command = 'cargo test -j1 ' .. test_func_name .. ' -v'
	local test_output = vim.fn.system(command)
	local lines = vim.fn.reverse(vim.fn.split(test_output, '\n'))

	local use_next = false
	for k, line in pairs(lines) do
		if vim.startswith(string.lower(vim.trim(line)), 'running') then
			local fragments = vim.fn.split(line)

			-- Use this line to get the path to the executable
			if use_next then
				local test_exec = vim.fn.split(fragments[2], '`')[1]
				return test_exec
				-- if #fragments < 3 then
				-- 	return test_exec
				-- end
				-- local test_name = vim.fn.split(fragments[3], '`')[1]
			end

			-- If there was more than zero tests run
			-- use the next available executable
			if vim.fn.str2nr(fragments[2]) > 0 then
				use_next = true
			end
		end
	end

	return ''
end

M.RunDebugger = function()
	local line_nr = vim.fn.line(".")
	local test_func_name = M.FindTestFunctionNameUnderCursor()

	if test_func_name ~= "" then
		local test_bin_path = M.FindTestExecutable(test_func_name)
		if test_bin_path == "" then
			vim.notify("Could not find test executable")
			return
		end
		local command = ':Termdebug ' .. test_bin_path
		vim.fn.execute(command)
	else
		M.RunDebuggerFromMain()
	end

	vim.cmd("wincmd p")
	vim.cmd("normal k")
	-- jump to the line nr where the debug was called from
	local jump_command = ':' .. line_nr
	vim.cmd(jump_command)

	vim.cmd(":Break")
	vim.cmd(":Program")
	vim.cmd(":hide")
	vim.cmd(":Run")
	vim.cmd("wincmd p")
end

M.DebugProject = function()
	local path_fragments = vim.fn.split(vim.fn.getcwd(), '/')
	local project_name = path_fragments[#path_fragments]
	local bin_dir = 'target/debug/'
	local bin_path = bin_dir .. project_name
	if vim.fn.filereadable(bin_path) then
		local command = ':Termdebug ' .. bin_path
		vim.cmd(command)
		vim.cmd("wincmd p")
	else
		vim.notify("Executable is not readable")
	end
end

M.RunDebuggerFromMain = function()
	print("building ...")
	-- Build project to ensure we have target/debug
	local command = 'cargo build'
	local output = vim.fn.system(command)
	M.DebugProject()
end

M.RunDebugAndBreak = function()
	-- Set a breakpoint if the debugger is running
	-- otherwise start the debugger and then set the breakpoint
	if M.in_debug_session then
		vim.cmd(':Break')
	else
		M.RunDebuggerFromMain()
		vim.cmd(':Break')
		vim.cmd(':Run')

		-- enter GDB window, insert an Enter and then scroll to tbe bottom
		-- scrolling to the bottom will activate autoscroll
		-- afterwards move back to the code window

		vim.cmd(":Gdb")
		local enter = vim.api.nvim_replace_termcodes("<CR>", true, false, true)
		local escape_terminal = vim.api.nvim_replace_termcodes("<C-l>", true, false, true)
		vim.api.nvim_feedkeys("i" .. enter, "t", false)
		vim.api.nvim_feedkeys(escape_terminal .. ":normal G" .. enter .. ":wincmd p" .. enter, "t", false)
		-- vim.cmd(":wincmd p")
	end
end

M.KillDebugger = function()
	if M.in_debug_session then
		vim.api.nvim_buf_delete(M.debugger_buf_id, { force = true })
	end
end

return M
