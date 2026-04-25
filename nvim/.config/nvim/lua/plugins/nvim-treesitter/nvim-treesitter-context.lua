return {
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
}
