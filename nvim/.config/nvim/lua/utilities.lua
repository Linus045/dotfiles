-- e.g. :lua P(vim.api)
-- now also :lua =vim.api works
function P(v)
	print(vim.inspect(v))
	return v
end

vim.cmd(
	"autocmd TextYankPost * silent! lua vim.highlight.on_yank {higroup=(vim.fn['hlexists']('HighlightedyankRegion') > 0 and 'HighlightedyankRegion' or 'IncSearch'), timeout=300}")

-- https://unix.stackexchange.com/a/8296
-- Used to paste vim command output into buffer (similar to r!ls for terminal commands)
-- :put =Exec('ls')
vim.cmd [[
funct! Exec(command)
    redir =>output
    silent exec a:command
    redir END
    let @o = output
    execute "put o"
    return ''
endfunct!
]]


local function Write_output(command)
	vim.cmd(":call Exec('" .. command .. "')")
end

vim.api.nvim_create_user_command('PrintVimCommandOutput', function(args)
	local command = args.args -- vim.fn.input('Command: ')
	Write_output(command)
end, {
	desc = "Write output of command to buffer",
	nargs = '*',
})



vim.api.nvim_create_user_command('PrintRustOutput', function(args)
	Write_output("RustRun")
end, {
	desc = "Calls RustRun and prints output in buffer",
	nargs = '*',
})


-- function CompleteCppVersion(ArgLead, CmdLine, CursorPos)
--   return { "11", "14", "17", "20" }
-- end

vim.cmd([[
fun CompleteCppVersion(A,L,P)
	return ["11", "14", "17", "20"]
endfun
]])

vim.api.nvim_create_user_command('PrintCppOutput', function(args)
	if args.args == "20" or args.args == "17" or args.args == "14" or args.args == "11" then
		Write_output("!g++ -std=c++" .. args.args .. " -Wall -Wextra -Wpedantic -Werror -o /tmp/a.out % && /tmp/a.out")
	else
		vim.cmd("echoerr 'Invalid C++ version'")
	end
end, {
	desc = "Compiles and run C++ file and prints output in buffer",
	nargs = 1,
	complete = "customlist,CompleteCppVersion",
})


vim.api.nvim_create_user_command('Lazygit', function(args)
	vim.cmd("tabnew | term lazygit")
	vim.cmd("startinsert")
end, {
	desc = "Opens lazygit in a new buffer",
})

-- easier editing of binary files
-- see :help using-xxd
-- vim.cmd([[
-- 	augroup Binary
-- 	  au!
-- 	  au BufReadPre  *.bin let &bin=1
-- 	  au BufReadPost *.bin if &bin | %!xxd
-- 	  au BufReadPost *.bin set ft=xxd | endif
-- 	  au BufWritePre *.bin if &bin | %!xxd -r
-- 	  au BufWritePre *.bin endif
-- 	  au BufWritePost *.bin if &bin | %!xxd
-- 	  au BufWritePost *.bin set nomod | endif
-- 	augroup END
-- ]])


vim.api.nvim_create_autocmd({ "TermOpen" }, {
	-- pattern = { "term://*" },
	callback = function()
		vim.api.nvim_win_set_option(0, "spell", false)
	end
})

vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
	pattern = { "man://*" },
	callback = function()
		vim.api.nvim_win_set_option(0, "spell", false)
	end
})

-- https://strdr4605.com/typescript-errors-into-vim-quickfix
-- use :make and :copen in typescript files to see errors
local augroup = vim.api.nvim_create_augroup("strdr4605", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
	pattern = "typescript,typescriptreact",
	group = augroup,
	command = "compiler tsc | setlocal makeprg=npx\\ tsc",
})


-- don't conceal when editing text
vim.api.nvim_create_autocmd({ "ModeChanged" }, {
	pattern = {
		"*:i", -- insert mode
		"*:v", -- visual mode
		"*:V", -- visual line mode
		"*:\22" -- visual block mode (see print(mode()))
	},
	callback = function()
		local filetype = vim.api.nvim_get_option_value("filetype", {})
		if (filetype == "tex") or (filetype == "markdown") then
			-- print("Disable conceallevel")
			vim.opt_local.conceallevel = 0
		end
	end
})

vim.api.nvim_create_autocmd({ "ModeChanged" }, {
	pattern = { "*:n" },
	callback = function()
		local filetype = vim.api.nvim_get_option_value("filetype", {})
		if (filetype == "tex") or (filetype == "markdown") then
			-- print("Enable conceallevel")
			vim.opt_local.conceallevel = vim.api.nvim_get_option_value("conceallevel", { scope = "global" })
		end
	end
})
