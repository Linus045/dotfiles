return {
	-- { "folke/tokyonight.nvim" },
	-- { "joshdick/onedark.vim" },
	-- { "sainnhe/gruvbox-material" },
	{
		"arcticicestudio/nord-vim",
		priority = 1000,
		config = function()
			local colorscheme = "nord"

			vim.cmd("colorscheme " .. colorscheme)

			-- Fix spelling underline color
			-- idk if this is the correct way but it works
			vim.cmd("highlight clear SpellBad")
			vim.cmd("highlight clear SpellCap")
			vim.cmd("highlight clear SpellLocal")
			vim.cmd("highlight clear SpellRare")
			vim.cmd("highlight SpellBad cterm=Underline ctermfg=NONE ctermbg=NONE term=Reverse gui=Undercurl guisp=Red")
			vim.cmd("highlight SpellCap cterm=Underline ctermfg=NONE ctermbg=NONE term=Reverse gui=Undercurl guisp=Red")
			vim.cmd("highlight SpellLocal cterm=Underline ctermfg=NONE ctermbg=NONE term=Reverse gui=Undercurl guisp=Red")
			vim.cmd("highlight SpellRare cterm=Underline ctermfg=NONE ctermbg=NONE term=Reverse gui=Undercurl guisp=Red")
		end
	},
}
