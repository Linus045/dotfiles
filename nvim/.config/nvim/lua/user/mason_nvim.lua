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

--[[


  Installed
    ✓ clang-format
    ✓ clangd
    ✓ cmake-language-server
    ✓ gopls
    ✓ lua-language-server
    ✓ rust-analyzer
    ✓ typescript-language-server
    ✓ vue-language-server

]]

mason_lspconfig.setup({
  ensure_installed = {
    "lua_ls",
    "rust_analyzer",
    "clangd",
    "gopls",
    -- "volar",
    -- "tsserver",

    -- Installed but invalid names, need to install manually via mason (no lspconfig integration?! idk)
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
