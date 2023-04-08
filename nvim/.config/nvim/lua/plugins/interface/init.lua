return {
	-- Shows current function scope/signature at the top of the screen
	"nvim-treesitter/nvim-treesitter-context",

	-- generates method/function list for the current file
	-- use with :Vista
	{
		"liuchengxu/vista.vim",
		cmd = "Vista",
		config = function()
			vim.g.vista_default_executive = 'nvim_lsp'
		end
	},

	-- Vista alternative to list methods/functions in the file
	{
		"SmiteshP/nvim-navbuddy",
		dependencies = {
			"neovim/nvim-lspconfig",
			"SmiteshP/nvim-navic",
			"MunifTanjim/nui.nvim"
		}
	},

	-- popup notification windows
	require("plugins.interface.notify"),

	-- show keyboard shortcuts
	require("plugins.interface.which-key_nvim"),

	-- smooth scrolling (eg. using PageUp/PageDown)
	"psliwka/vim-smoothie",

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
	{ "HiPhish/nvim-ts-rainbow2", dependencies = { "nvim-treesitter/nvim-treesitter" } },


	-- -- If i ever use Sql
	-- tools to manage SQL stuff
	-- use("tpope/vim-dadbod")
	-- use({ "kristijanhusak/vim-dadbod-completion" })
	-- use({ "kristijanhusak/vim-dadbod-ui" })


	{
		"luukvbaal/statuscol.nvim",
		config = function()
			require("statuscol").setup({
				setopt = true
			})
		end
	},

}
