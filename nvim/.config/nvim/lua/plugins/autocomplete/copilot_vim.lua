-- Copilot (Disable due to high cpu for some reason)
return {
	"git@github.com:github/copilot.vim.git",
	config = function()
		-- change github copilot keybindings Shift+Right Arrow
		vim.cmd([[imap <silent><script><expr> <S-Right> copilot#Accept("\<CR>")]])
		vim.g.copilot_no_tab_map = true
	end
}
