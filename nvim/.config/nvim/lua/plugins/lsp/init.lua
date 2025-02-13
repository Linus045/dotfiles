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
				modes = {
					symbols = {
						focus = true,
						win = {
							type = "split",
							relative = "win",
							position = "right",
							size = 0.3,
						},
					},
					diagnostic_preview_float = {
						mode = "diagnostics",
						preview = {
							type = "float",
							relative = "editor",
							border = "rounded",
							title = "Preview",
							title_pos = "center",
							position = { 0, -2 },
							size = { width = 0.4, height = 0.4 },
							zindex = 200,
						},
						filter = {
							any = {
								buf = 0,           -- current buffer
								{
									severity = vim.diagnostic.severity.ERROR, -- errors only
									-- limit to files in the current project
									function(item)
										return item.filename:find((vim.loop or vim.uv).cwd(), 1, true)
									end,
								},
							},
						},
					},
					quickfix_preview_float = {
						mode = "quickfix",
						preview = {
							type = "float",
							relative = "editor",
							border = "rounded",
							title = "Preview",
							title_pos = "center",
							position = { 0, -2 },
							size = { width = 0.4, height = 0.4 },
							zindex = 200,
						},
					},
				},
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
