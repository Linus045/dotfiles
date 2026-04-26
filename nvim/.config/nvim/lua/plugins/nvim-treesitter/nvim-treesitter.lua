-- better highlightings and other useful features
return {
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		build = ':TSUpdate',
		config = function()
			require('nvim-treesitter').setup {
				-- Directory to install parsers and queries to (prepended to `runtimepath` to have priority)
				install_dir = vim.fn.stdpath('data') .. '/site'
			}

			local parsers = {
				"c",
				"lua",
				"vim",
				"vimdoc",
				"cpp",
				"markdown",
				"javascript",
				"html",
				"css",
				"typescript",
				"json",
				"rust",
				"htmldjango",
				"make",
				"cmake",
				"fish",
				"python",
				"yaml",
				"toml",
				"bash",
				"luadoc",
				"tsx",
				"nginx",
				"desktop",
				"html_tags",
				"jsx",
				"svelte",
			}
			require("nvim-treesitter").install(parsers)
		end
	}
}
