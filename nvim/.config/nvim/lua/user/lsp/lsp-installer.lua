local status_ok, lsp_installer = pcall(require, "nvim-lsp-installer")
if not status_ok then
	return
end

-- Register a handler that will be called for all installed servers.
-- Alternatively, you may also register handlers on specific server instances instead (see example below).

require("nvim-lsp-installer").setup {
  ui = {
    icons = {
        server_installed = '✓',
        server_pending = '➜',
        server_uninstalled = '✗',
    },
  },
}
local lspconfig = require("lspconfig")

lspconfig.sumneko_lua.setup {}
lspconfig.tsserver.setup {}
