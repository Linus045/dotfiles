-- multi cursor
return {
	"mg979/vim-visual-multi",
	config = function()
		-- Vim Visual multi cursor keymaps
		-- vim.g.VM_mouse_mappings = 1
		-- vim.g.VM_theme = "sand"
		vim.g.VM_highlight_matches = "red"
		vim.g.VM_maps = {
			-- ["Find Under"] = "<C-d>",
			-- ["Find Subword Under"] = "<C-d>",
			["Undo"] = "u",
			["Redo"] = "<C-r>",
		}
	end
}
