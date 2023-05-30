return {
	-- { "folke/tokyonight.nvim" },
	-- { "joshdick/onedark.vim" },
	-- { "sainnhe/gruvbox-material" },
	{
		"arcticicestudio/nord-vim",
		priority = 1000,
		config = function()
			local colorscheme = "nord"


			vim.api.nvim_create_autocmd({ "ColorScheme" }, {
				callback = function(ev)
					-- Fix spelling underline color
					-- idk if this is the correct way but it works
					vim.cmd("highlight clear SpellBad")
					vim.cmd("highlight clear SpellCap")
					vim.cmd("highlight clear SpellLocal")
					vim.cmd("highlight clear SpellRare")
					vim.cmd("highlight SpellBad cterm=Underline ctermfg=NONE ctermbg=NONE term=Reverse gui=Undercurl guisp=Green")
					vim.cmd("highlight SpellCap cterm=Underline ctermfg=NONE ctermbg=NONE term=Reverse gui=Undercurl guisp=Green")
					vim.cmd(
						"highlight SpellLocal cterm=Underline ctermfg=NONE ctermbg=NONE term=Reverse gui=Undercurl guisp=Green")
					vim.cmd("highlight SpellRare cterm=Underline ctermfg=NONE ctermbg=NONE term=Reverse gui=Undercurl guisp=Green")

					-- set color for :Termdebug
					vim.cmd("highlight debugPC term=reverse ctermbg=4 guibg=darkblue")

					vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#8cbee2" })

					-- vim.cmd("hi DiffAdd cterm=NONE ctermfg=NONE    gui=none    guifg=NONE          guibg=#bada9f")
					-- vim.cmd("hi DiffChange   gui=none    guifg=NONE          guibg=#e5d5ac ")
					-- vim.cmd("hi DiffDelete   gui=bold    guifg=#ff8080       guibg=#ffb0b0 ")
					-- vim.cmd("hi DiffText     gui=none    guifg=NONE          guibg=#8cbee2 ")
				end
			})

			vim.cmd("colorscheme " .. colorscheme)
		end
	},
}
