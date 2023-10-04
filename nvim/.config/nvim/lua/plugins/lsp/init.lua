return {
	require("plugins.lsp.mason_nvim"),

	-- LSP server configurations
	"neovim/nvim-lspconfig",

	-- better diagnostics
	{
		"folke/trouble.nvim",
		config = function()
			local trouble = require("trouble")
			trouble.setup {
				position = "bottom", -- position of the list can be: bottom, top, left, right
				auto_fold = true,
			}
		end
	},

	{
		'ericpubu/lsp_codelens_extensions.nvim',
		dependencies = { "nvim-lua/plenary.nvim", "mfussenegger/nvim-dap" },
		config = function()
			require("codelens_extensions").setup {
				init_rust_commands = true
			}
		end,
	},

	"rust-lang/rust.vim"
}
