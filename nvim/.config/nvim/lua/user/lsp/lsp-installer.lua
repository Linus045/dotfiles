local status_ok, mason = pcall(require, "mason")
if not status_ok then
  vim.notify("mason.nvim not found")
  return
end

local status_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
if not status_ok then
  vim.notify("williamboman/mason-lspconfig.nvim not found")
  return
end

local status_ok, lsp_status = pcall(require, 'lsp-status')
if not status_ok then
  vim.notify('File lsp-installer.lua: lsp_status not found.')
  return
end

local status_ok, lspconfig = pcall(require, 'lspconfig')
if not status_ok then
  vim.notify('File lsp-installer.lua: lspconfig not found.')
  return
end

local lsps = mason_lspconfig.get_installed_servers()

for _, server in pairs(lsps) do
  local opts = {
    on_attach = require("user.lsp.handlers").on_attach,
    capabilities = require("user.lsp.handlers").capabilities,
  }
  opts.capabilities = vim.tbl_extend('keep', opts.capabilities or {}, lsp_status.capabilities)

  local has_custom_opts, server_custom_opts = pcall(require, "user.lsp.settings." .. server)
  if has_custom_opts then
    opts = vim.tbl_deep_extend("force", opts, server_custom_opts)
    -- vim.notify("[LSP-Installer] Custom options for " .. server .. " loaded")
  else
    -- print("[LSP-Installer] NO custom options for " .. server .. " found")
  end
  lspconfig[server].setup(opts)
end
