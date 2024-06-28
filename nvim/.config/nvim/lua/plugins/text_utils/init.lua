-- mostly a list of old plugins I used
return {

	-- { "nvim-treesitter/playground" },

	-- Automatically inserts brackets, etc. when needed
	-- {"windwp/nvim-autopairs"},

	-- easier code navigation
	-- {"ggandor/lightspeed.nvim"},

	-- surround text easier (e.g. with ", {. <, etc.)
	{
		"kylechui/nvim-surround",
		version = "*", -- Use for stability; omit to use `main` branch for the latest features
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup({
				-- Configuration here, or leave empty to use defaults
			})
		end
	},

	"chrisbra/unicode.vim",


	-- converts between the number representations encountered when programming,
	-- that is in addition to decimal, hex, octal, and binary representation.
	-- gA shows number under cursor in different formats
	-- crd, crXm cro and crb will convert the number to the given format
	{ "glts/vim-radical", dependencies = { "glts/vim-magnum" } },

	require("plugins.text_utils.colorscheme"),
	require("plugins.text_utils.comment_nvim"),
	require("plugins.text_utils.fidget_nvim"),
	require("plugins.text_utils.lsp-status_nvim"),
	require("plugins.text_utils.lualine"),
	require("plugins.text_utils.null-ls_nvim"),
	require("plugins.text_utils.nvim-treesitter"),
	require("plugins.text_utils.refactoring"),
	require("plugins.text_utils.vim-visual-multi"),
	{
		"RaafatTurki/hex.nvim",
		config = function()
			local hex = require "hex"
			local original_is_file_binary_pre_read = hex.cfg.is_file_binary_pre_read
			local original_is_file_binary_post_read = hex.cfg.is_file_binary_post_read

			require 'hex'.setup {
				is_file_binary_pre_read = function()
					local is_binary = original_is_file_binary_pre_read()
					if is_binary then
						vim.notify("[hex.nvim] Use :HexToggle to switch between hex and text view")
					end
					return is_binary
				end,

				is_file_binary_post_read = function()
					local is_binary = original_is_file_binary_post_read()
					if is_binary then
						vim.notify("[hex.nvim] Use :HexToggle to switch between hex and text view")
					end
					return is_binary
				end,
			}
		end
	},
	require("plugins.text_utils.vim-glsl"),
	require("plugins.text_utils.json_schema"),
}
