-- Use a protected call so we don't error out on first use
local status_ok, lsp = pcall(require, "lspconfig")
if not status_ok then
  vim.notify("lspconfig not found")
  return
end

-- define before calling require('coq')
vim.g.coq_settings = {
  auto_start = 'shut-up'
}

-- Use a protected call so we don't error out on first use
local status_ok, coq = pcall(require, "coq")
if not status_ok then
  vim.notify("coq not found")
  return
end

vim.g.coq_settings = {
  auto_start = 'shut-up',
  keymap = {
    recommended = true,
    jump_to_mark = '<c-e>'
  }
}

lsp.tsserver.setup{}
lsp.tsserver.setup(coq.lsp_ensure_capabilities{})
vim.cmd('COQnow -s')
