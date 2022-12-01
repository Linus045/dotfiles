local status_ok, mason = pcall(require, "mason")
if not status_ok then
  vim.notify("mason.nvim not found")
  return
end

mason.setup({
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗"
    }
  }
})


local status_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
if not status_ok then
  vim.notify("williamboman/mason-lspconfig.nvim not found")
  return
end

mason_lspconfig.setup({
  ensure_installed = {
    "sumneko_lua",
    "rust_analyzer",
    "volar",
    "tsserver",
    "clangd",
    "gopls",
    "clangd",

    -- Installed but invalid names, need to install manually via mason (no lspconfig integration?! idk)
    -- "lua-language-server",
    -- "clang-format",
    -- "cmake-language-server",
    -- "debugpy",
    -- "ltex-ls",
    -- "mypy",
    -- "python-lsp-server",
    -- "typescript-language-server",
    -- "vue-language-server",

    -- "codelldb"
  }
})
