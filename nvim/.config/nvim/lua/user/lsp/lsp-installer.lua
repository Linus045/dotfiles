local status_ok, lsp_installer = pcall(require, "nvim-lsp-installer")
if not status_ok then
  return
end

-- Register a handler that will be called for all installed servers.
-- Alternatively, you may also register handlers on specific server instances instead (see example below).

require("nvim-lsp-installer").setup({
  ui = {
    icons = {
      server_installed = "✓",
      server_pending = "➜",
      server_uninstalled = "✗",
    },
  },
})
local lspconfig = require("lspconfig")

local lsp_status = require "lsp-status"

local lsps = require 'nvim-lsp-installer.servers'.get_installed_server_names()

lsp_installer.setup({
  ensure_installed = lsps,
})

for _, server in pairs(lsps) do
  local opts = {
    on_attach = require("user.lsp.handlers").on_attach,
    capabilities = require("user.lsp.handlers").capabilities,
  }
  opts.capabilities = vim.tbl_extend('keep', opts.capabilities or {}, lsp_status.capabilities)

  local has_custom_opts, server_custom_opts = pcall(require, "user.lsp.settings." .. server)
  if has_custom_opts then
    opts = vim.tbl_deep_extend("force", opts, server_custom_opts)
    -- print("[LSP-Installer] Custom options for " .. server .. " loaded")
  end
  lspconfig[server].setup(opts)
end
