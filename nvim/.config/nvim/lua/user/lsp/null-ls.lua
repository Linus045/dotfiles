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

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
null_ls.setup({
  debug = false,
  sources = {
    diagnostics.mypy,
    code_actions.refactoring,
    -- formatting.black
    -- diagnostics.eslint_d,
    -- code_actions.eslint_d,
    -- null_ls.builtins.code_actions.gitsigns,
    -- formatting.prettier.with({ extra_args = { "--no-semi", "--double-quote", "--jsx-double-quote" } }),
  },
  on_attach = function(client, bufnr)
    if client.supports_method("textDocument/formatting") then
      vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          local lspFormat = require "lsp-format"
          local lspDisabled = lspFormat.disabled or lspFormat.disabled_filetypes[vim.bo.filetype] or vim.b.format_saving
          if not lspDisabled then
            vim.lsp.buf.format({ bufnr = bufnr })
          end
        end,
      })
    end
  end,
})
