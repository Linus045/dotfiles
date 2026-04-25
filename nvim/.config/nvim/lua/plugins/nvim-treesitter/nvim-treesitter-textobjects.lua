return {
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",
		init = function()
			-- Disable entire built-in ftplugin mappings to avoid conflicts.
			-- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin for built-in ftplugins.
			vim.g.no_plugin_maps = true

			-- Or, disable per filetype (add as you like)
			-- vim.g.no_python_maps = true
			-- vim.g.no_ruby_maps = true
			-- vim.g.no_rust_maps = true
			-- vim.g.no_go_maps = true
		end,
		config = function()
			require("nvim-treesitter-textobjects").setup {
				textobjects = {
					swap = {
						enable = true,
						swap_next = {
							["<leader>ml"] = "@parameter.inner",
							["<A-l>"] = "@parameter.inner",
						},
						swap_previous = {
							["<leader>mh"] = "@parameter.inner",
							["<A-h>"] = "@parameter.inner",
						},
					},
					lsp_interop = {
						enable = true,
						border = 'none',
						floating_preview_opts = {},
						peek_definition_code = {
							["<leader>k"] = "@function.outer",
							["<leader>K"] = "@class.outer",
						},

					},
				},
			}
		end,
	}
}
