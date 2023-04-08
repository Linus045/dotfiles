-- Insert annotations for functions, classes, etc.
return {
	"danymat/neogen",
	config = function()
		require("neogen").setup({
			snippet_engine = "luasnip",
		})
	end,
	requires = "nvim-treesitter/nvim-treesitter",
}
