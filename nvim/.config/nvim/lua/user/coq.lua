-- Use a protected call so we don't error out on first use
local status_ok, lsp = pcall(require, "lspconfig")
if not status_ok then
  vim.notify("lspconfig not found")
  return
end

-- Use a protected call so we don't error out on first use
local status_ok, coq = pcall(require, "coq")
if not status_ok then
  vim.notify("coq not found")
  return
end

lsp.tsserver.setup{}
lsp.tsserver.setup(coq.lsp_ensure_capabilities{})
vim.cmd('COQnow -s')
