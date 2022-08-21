local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
  vim.notify("null-ls not found, please install it")
  return
end

-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
local formatting = null_ls.builtins.formatting
-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
local diagnostics = null_ls.builtins.diagnostics

local code_actions = null_ls.builtins.code_actions

null_ls.setup({
  debug = false,
  sources = {
    diagnostics.eslint,
    code_actions.eslint,
    null_ls.builtins.code_actions.gitsigns,
    -- formatting.prettier.with({ extra_args = { "--no-semi", "--double-quote", "--jsx-double-quote" } }),
  },
})
