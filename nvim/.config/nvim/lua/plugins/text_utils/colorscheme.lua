return {
	-- { "folke/tokyonight.nvim" },
	-- { "joshdick/onedark.vim" },
	-- { "sainnhe/gruvbox-material" },
	{
		"folke/tokyonight.nvim",
		-- "arcticicestudio/nord-vim",
		lazy = false,
		priority = 1000,
		config = function()
			-- local colorscheme = "nord"
			local colorscheme = "tokyonight-night"

			require("tokyonight").setup({
				-- Change the "hint" color to the "orange" color, and make the "error" color bright red
				style = "moon",
				on_colors = function(colors)
				end,
				on_highlights = function(hl, c)
					-- original color: #444a73
					-- override with a more readable color (highlights unused variables)
					hl.DiagnosticUnnecessary = { fg = "#6E8096" }
				end
			})

			vim.api.nvim_create_autocmd({ "ColorScheme" }, {
				callback = function(ev)
					-- Fix spelling underline color
					-- idk if this is the correct way but it works
					vim.cmd("highlight clear SpellBad")
					vim.cmd("highlight clear SpellCap")
					vim.cmd("highlight clear SpellLocal")
					vim.cmd("highlight clear SpellRare")
					vim.cmd(
						"highlight SpellBad cterm=Underline ctermfg=NONE ctermbg=NONE term=Reverse gui=Undercurl guisp=Green")
					vim.cmd(
						"highlight SpellCap cterm=Underline ctermfg=NONE ctermbg=NONE term=Reverse gui=Undercurl guisp=Green")
					vim.cmd(
						"highlight SpellLocal cterm=Underline ctermfg=NONE ctermbg=NONE term=Reverse gui=Undercurl guisp=Green")
					vim.cmd(
						"highlight SpellRare cterm=Underline ctermfg=NONE ctermbg=NONE term=Reverse gui=Undercurl guisp=Green")

					-- set color for :Termdebug
					vim.cmd("highlight debugPC term=reverse ctermbg=4 guibg=darkblue")

					vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#8cbee2" })

					vim.cmd("highlight CursorLineNr guifg=#E85D54")
					vim.cmd("highlight LineNr guifg=#49807E")

					vim.cmd([[highlight clear DiffAdd]])
					vim.cmd([[highlight clear DiffDelete]])
					vim.cmd([[highlight clear DiffChange]])
					vim.cmd([[highlight clear DiffText]])

					vim.cmd([[highlight DiffAdd gui=bold guifg=None guibg=#062e27]])
					vim.cmd([[highlight DiffDelete gui=none guifg=Red guibg=#06272e]])
					vim.cmd([[highlight DiffChange gui=none guifg=SlateBlue guibg=#06272e]])
					vim.cmd([[highlight DiffText gui=none guifg=None guibg=#0b4a57]])

					vim.cmd([[highlight Folded guifg=#82aaff guibg=#222436]])
					-- vim.notify("Reloaded colorscheme: " .. colorscheme)
				end
			})

			vim.cmd("colorscheme " .. colorscheme)
		end,
		opts = {},
	},
}
