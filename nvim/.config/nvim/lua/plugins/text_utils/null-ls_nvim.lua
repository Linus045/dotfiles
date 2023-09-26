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

		local function on_attach()
			-- print("Null-ls attached")
		end

		null_ls.setup({
			debug = false,
			log_level = "trace",
			on_attach = on_attach,
			root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".git"),
			sources = {
				-- diagnostics.mypy,
				code_actions.refactoring,
				-- latex support for formatting and linting
				null_ls.builtins.formatting.latexindent,
				-- null_ls.builtins.formatting.prettier.with({
				-- 	extra_args = { "--no-semi", "--double-quote", "--jsx-double-quote" },
				-- }),
				null_ls.builtins.diagnostics.chktex.with({
					filetypes = { "tex", "bib" },
					args = {
						-- Disable printing version information to stderr
						"-q",
						-- Format output
						"-f%l:%c:%d:%k:%n:%m\n",
						"-n24",
						"-n2",
					},
				}),
				-- null_ls.builtins.diagnostics.cppcheck,
				-- formatting.black
				diagnostics.eslint.with({
					filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
					config = {
						parserOptions = {
							sourceType = "module",
						},
						ecmaFeatures = {
							modules = true,
							spread = true,
							restParams = true
						},
					}
				})
				-- code_actions.eslint_d,
				-- null_ls.builtins.code_actions.gitsigns,
			}
		})

		vim.api.nvim_create_user_command("NullLsRootDir", function()
			local client = require("null-ls.client").get_client()
			if client then
				local root_dir = client.config.root_dir
				print("Null-ls root_dir: " .. root_dir)
			else
				print(
					"Null-ls disabled - no root_dir. Consider creating a git repo or adding .null-ls-root file in the root of your project")
			end
		end, {})
	end,
}
