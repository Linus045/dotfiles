-- better highlightings and other useful features
return {
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		build = ':TSUpdate',
		config = function()
			local configs = require("nvim-treesitter.config")
			configs.setup {
				install_dir = vim.fn.stdpath('data') .. '/site',

				-- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
				-- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
				-- the name of the parser)
				-- list of language that will be disabled
				disable = {},

				-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
				-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
				-- Using this option may slow down your editor, and you may see some duplicate highlights.
				-- Instead of true it can also be a list of languages
				additional_vim_regex_highlighting = true,
				-- Automatically install missing parsers when entering buffers
				auto_install = true,
				highlight = {
					enable = true, -- false will disable the whole extension
					disable = { 'latex' },
				},
				fold = { enable = true },
				rainbow = {
					enable = true,
					-- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
					extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
					max_file_lines = nil, -- Do not enable for files with more than n lines, int
					-- colors = {}, -- table of hex strings
					-- termcolors = {} -- table of colour name strings
				},

			}
		end
	},

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
	-- {
	-- 	"nvim-treesitter/nvim-treesitter-textobjects",
	-- 	branch = "main",
	-- 	after = "nvim-treesitter",
	-- 	requires = "nvim-treesitter/nvim-treesitter",
	-- 	init = function()
	-- 		vim.g.no_plugin_maps = true
	-- 	end,
	-- 	config = function()
	-- 		local config = require 'nvim-treesitter.config'
	-- 		config.setup {
	-- 		}
	-- 	end
	-- },
}
