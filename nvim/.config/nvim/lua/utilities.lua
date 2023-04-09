-- e.g. :lua P(vim.api)
-- now also :lua =vim.api works
function P(v)
	print(vim.inspect(v))
	return v
end

vim.cmd(
	"autocmd TextYankPost * silent! lua vim.highlight.on_yank {higroup=(vim.fn['hlexists']('HighlightedyankRegion') > 0 and 'HighlightedyankRegion' or 'IncSearch'), timeout=300}")


-- easier editing of binary files
-- see :help using-xxd
vim.cmd([[
	augroup Binary
	  au!
	  au BufReadPre  *.bin let &bin=1
	  au BufReadPost *.bin if &bin | %!xxd
	  au BufReadPost *.bin set ft=xxd | endif
	  au BufWritePre *.bin if &bin | %!xxd -r
	  au BufWritePre *.bin endif
	  au BufWritePost *.bin if &bin | %!xxd
	  au BufWritePost *.bin set nomod | endif
	augroup END
]])


-- vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
--   pattern = { "*.c", "*.h", "*.cpp" },
--   callback = function()
--     vim.api.nvim_buf_set_option(0, "tabstop", 4)
--     vim.api.nvim_buf_set_option(0, "shiftwidth", 4)
--   end
-- })

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
