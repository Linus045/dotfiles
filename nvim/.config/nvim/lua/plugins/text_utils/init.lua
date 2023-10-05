-- mostly a list of old plugins I used
return {

	-- { "nvim-treesitter/playground" },

	-- Automatically inserts brackets, etc. when needed
	-- {"windwp/nvim-autopairs"},

	-- easier code navigation
	-- {"ggandor/lightspeed.nvim"},

	-- surround text easier (e.g. with ", {. <, etc.)
	{ "kylechui/nvim-surround" },
	-- converts between the number representations encountered when programming,
	-- that is in addition to decimal, hex, octal, and binary representation.
	-- gA shows number under cursor in different formats
	-- crd, crXm cro and crb will convert the number to the given format
	{ "glts/vim-radical",      dependencies = { "glts/vim-magnum" } },

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
			require 'hex'.setup()
		end
	},
	require("plugins.text_utils.vim-glsl"),
	require("plugins.text_utils.json_schema"),
}
