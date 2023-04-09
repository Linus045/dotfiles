return {
	"jose-elias-alvarez/null-ls.nvim",
	dependencies = {
		"lukas-reineke/lsp-format.nvim",
	},
	config = function()
		local null_ls = require("null-ls")
		-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
		local formatting = null_ls.builtins.formatting
		-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
		local diagnostics = null_ls.builtins.diagnostics

		local code_actions = null_ls.builtins.code_actions

		null_ls.setup({
			debug = false,
			sources = {
				-- diagnostics.mypy,
				code_actions.refactoring,
				-- null_ls.builtins.diagnostics.cppcheck,
				-- formatting.black
				-- diagnostics.eslint_d,
				-- code_actions.eslint_d,
				-- null_ls.builtins.code_actions.gitsigns,
				-- formatting.prettier.with({ extra_args = { "--no-semi", "--double-quote", "--jsx-double-quote" } }),
			}
		})
	end,
}
