return {
	{
		"chrisgrieser/nvim-lsp-endhints",
		event = "LspAttach",
		opts = {}, -- required, even if empty
	},
	-- Shows current function scope/signature at the top of the screen
	{
		"nvim-treesitter/nvim-treesitter-context",
		config = function()
			require 'treesitter-context'.setup {
				mode = 'cursor', -- Line used to calculate context. Choices: 'cursor', 'topline'
				multiwindow = true, -- Enable multiwindow support.
				max_lines = 2,
				trim_scope = 'outer',
			}
		end
	},

	-- Replaced with Trouble symbols
	-- generates method/function list for the current file
	-- use with :Vista
	-- {
	-- 	"liuchengxu/vista.vim",
	-- 	cmd = "Vista",
	-- 	config = function()
	-- 		vim.g.vista_default_executive = 'nvim_lsp'
	-- 	end
	-- },

	-- Vista alternative to list methods/functions in the file
	{
		"SmiteshP/nvim-navbuddy",
		dependencies = {
			"neovim/nvim-lspconfig",
			"SmiteshP/nvim-navic",
			"MunifTanjim/nui.nvim"
		}
	},

	{
		"nanotee/zoxide.vim"
	},

	-- popup notification windows
	require("plugins.interface.notify"),

	-- show keyboard shortcuts
	require("plugins.interface.which-key_nvim"),

	-- smooth scrolling (eg. using PageUp/PageDown)
	-- "psliwka/vim-smoothie",

	-- better file explorer sidebar
	require("plugins.interface.nvim-tree"),

	-- shows undo/redo tree structure
	"mbbill/undotree",

	-- floating terminal in nvim
	{
		"akinsho/toggleterm.nvim",
		config = function()
			local toggleterm = require("toggleterm")
			toggleterm.setup({
				open_mapping = [[<c-\>]],
				close_on_exit = true, -- close the terminal window when the process exits
			})
		end
	},

	-- git sings support on the sidebar
	require("plugins.interface.gitsigns_nvim"),

	-- show git changes on the side (replaced with gitsigns)
	-- use "airblade/vim-gitgutter"

	-- allow transparent code
	{
		"xiyaowong/nvim-transparent",
		config = function()
			local transparent = require("transparent")
			transparent.setup({
				extra_groups = {},
				exclude_groups = {}, -- table: groups you don't want to clear
			})
		end
	},

	-- rainbow brackets
	{ "hiphish/rainbow-delimiters.nvim", dependencies = { "nvim-treesitter/nvim-treesitter" } },


	-- A collection of QoL plugins for Neovim
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		--@type snacks.Config
		opts = {
			bigfile = { enabled = true },
			dashboard = { enabled = true },
			explorer = { enabled = false },
			indent = { enabled = true },
			input = {
				enabled = true,
				icon = " ",
				icon_hl = "SnacksInputIcon",
				icon_pos = "left",
				prompt_pos = "title",
				win = {
					style = "input",
					relative = "cursor",
				},
				expand = true,
			},
			picker = { enabled = false },

			notifier = { enabled = false },
			quickfile = { enabled = false },
			scope = { enabled = false },
			scroll = { enabled = true },
			statuscolumn = {
				enabled = true,
				folds = {
					open = true,

				},

			},
			words = { enabled = true },
			zen = {
				enabled = true,
				toggles = {
					dim = true,
					git_signs = false,
					mini_diff_signs = false,
					diagnostics = true,
					inlay_hints = true,
				},
				show = {
					statusline = false, -- can only be shown when using the global statusline
					tabline = false,
				},
				win = {
					style = "zen",
					enter = true,
					fixbuf = false,
					minimal = false,
					width = 140,
					height = 0,
					backdrop = { transparent = true, blend = 40 },
					keys = { q = false },
					zindex = 40,
					wo = {
						winhighlight = "NormalFloat:Normal",
					},
					w = {
						snacks_main = true,
					},
				},


			},
		},
	},

	-- -- If i ever use Sql
	-- tools to manage SQL stuff
	-- use("tpope/vim-dadbod")
	-- use({ "kristijanhusak/vim-dadbod-completion" })
	-- use({ "kristijanhusak/vim-dadbod-ui" })


	-- {
	--     "luukvbaal/statuscol.nvim",
	--     config = function()
	--         require("statuscol").setup({
	--             setopt = true
	--         })
	--     end
	-- },

}
