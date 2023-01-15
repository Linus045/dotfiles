local M = {}

local keymap = require("user.utilities").keymap
if keymap == nil then
  vim.notify("File keymaps.lua: Can't setup keymaps, error loading user.utilities")
  return
end


-- TODO: backfill this to template
M.setup = function()
  local signs = {
    { name = "DiagnosticSignError", text = "" },
    { name = "DiagnosticSignWarn", text = "" },
    { name = "DiagnosticSignHint", text = "" },
    { name = "DiagnosticSignInfo", text = "" },
  }

  for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
  end

  local config = {
    -- disable virtual text
    virtual_text = true,
    -- show signs
    signs = {
      active = signs,
    },
    update_in_insert = true,
    underline = true,
    severity_sort = true,
    float = {
      focusable = false,
      style = "minimal",
      border = "rounded",
      source = "always",
      header = "",
      prefix = "",
    },
  }

  vim.diagnostic.config(config)

  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "rounded",
  })

  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = "rounded",
  })
end

local function lsp_highlight_document(client, bufnr)
  -- Set autocommands conditional on server_capabilities
  if client.server_capabilities.documentHighlightProvider then
    vim.api.nvim_exec(
      [[
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]] ,
      false
    )
  end
end

-- Rename with window: https://www.reddit.com/r/neovim/comments/nsfv7h/rename_in_floating_window_with_neovim_lsp/
local function dorename(win)
  local new_name = vim.trim(vim.fn.getline("."))
  vim.api.nvim_win_close(win, true)
  vim.lsp.buf.rename(new_name)
end

local function rename()
  local opts = {
    relative = "cursor",
    row = 0,
    col = 0,
    width = 30,
    height = 1,
    style = "minimal",
    border = "single",
  }
  local cword = vim.fn.expand("<cword>")
  local buf = vim.api.nvim_create_buf(false, true)
  local win = vim.api.nvim_open_win(buf, true, opts)
  local fmt = "<cmd>lua Rename.dorename(%d)<CR>"

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, { cword })
  vim.api.nvim_buf_set_keymap(buf, "i", "<CR>", string.format(fmt, win), { silent = true })
end

_G.Rename = {
  rename = rename,
  dorename = dorename,
}

local function lsp_keymaps(client, bufnr)
  local opts = { noremap = true, silent = true }
  -- local filetype = vim.api.nvim_buf_get_option(0, "filetype")
  keymap("n", "gq", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts, "Type Defintions", nil, nil, bufnr)
  keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts, "Goto Declaration", nil, nil, bufnr)
  keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts, "Goto Definition", nil, nil, bufnr)
  -- TODO: Causes problems with :Man (jumping to references no longer works)
  -- Workaround use Ctrl+] to jump
  keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts, "HOVER INFO", nil, nil, bufnr)
  keymap("n", "<C-K>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts, "Signature Help", nil, nil, bufnr)
  -- vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
  keymap("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts, "Goto Implementation [Telescope]", nil, nil, bufnr)
  -- vim.api.nvim_buf_set_keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
  keymap("n", "gr", "<cmd>Telescope lsp_references<CR>", opts, "Goto References [Telescope]", nil, nil, bufnr)
  keymap("n", "gl", '<cmd>lua vim.diagnostic.open_float({ border = "rounded", wrap = true, max_width = 80 })<CR>', opts,
    "Show Diagnostics", nil, nil, bufnr)

  -- Create own file/directory that allows custom commands/keybindings per language/lsp provider
  -- e.g. lsp/configurations/clangd.lua which contains this command or a more advanced version that can search for implementations if used on a function signature etc.
  -- https://github.com/neovim/nvim-lspconfig/blob/c5dae15c0c94703a0565e8ba35a9f5cb96ca7b8a/lua/lspconfig/server_configurations/clangd.lua#L52-L59
  keymap("n", "gt", '<cmd>ClangdSwitchSourceHeader<CR>', opts, "Switch between source/header file", nil, nil, bufnr)
  keymap("n", "<leader>gl", "<cmd>lua vim.lsp.codelens.run()<CR>", opts, "Codelens", nil, nil, bufnr)
  keymap("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts, "Rename variable", nil, nil, bufnr)
  keymap("n", "<leader>q", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts, "Diagnostics quickfix list", nil, nil, bufnr)
  keymap("n", "[d", '<cmd>lua vim.diagnostic.goto_prev({ border = "rounded" })<CR>', opts,
    "Goto previous diagnostic result", nil, nil,
    bufnr)
  keymap("n", "]d", '<cmd>lua vim.diagnostic.goto_next({ border = "rounded" })<CR>', opts, "Goto next diagnostic result"
    , nil, nil,
    bufnr)
  keymap("n", "<leader>F", "<cmd>lua vim.lsp.buf.format(nil, 1000)<CR>", opts, "Format file", nil, nil, bufnr)
  keymap("n", "[q", '<cmd>cprevious<CR>', opts, "Jump to previous quickfix entry", nil, nil, bufnr)
  keymap("n", "]q", '<cmd>cnext<CR>', opts, "Jump to next quickfix entry", nil, nil, bufnr)
  vim.cmd([[:command! F lua vim.lsp.buf.format(nil, 1000)]])

  vim.bo.omnifunc = "v:lua.vim.lsp.omnifunc"
end

local function lsp_codelens(client, bufnr)
  local opts = { noremap = true, silent = true }
  local filetype = vim.api.nvim_buf_get_option(0, "filetype")
  if client.server_capabilities.codeLensProvider then
    if filetype ~= "elm" then
      vim.cmd([[
        augroup lsp_document_codelens
          au! * <buffer>
          autocmd BufEnter ++once         <buffer> lua require"vim.lsp.codelens".refresh()
          autocmd BufWritePost,CursorHold <buffer> lua require"vim.lsp.codelens".refresh()
        augroup END
      ]])
    end
  end
end

require("lsp-status").register_progress()
require("lsp-format").setup({})

M.on_attach = function(client, bufnr)
  -- vim.notify("Attaching LSP Client: " .. client.name .. " to buffer")
  lsp_keymaps(client, bufnr)
  lsp_highlight_document(client, bufnr)

  require("lsp-status").on_attach(client)

  -- Register folds for: pierreglaser/folding-nvim
  local status_ok, folding = pcall(require, 'folding')
  if status_ok then
    folding.on_attach()
  else
    -- vim.notify('File handlers.lua: folding not found.')
  end

  -- Register automatic formatting: lsp-format.nvim
  require("lsp-format").on_attach(client)


  lsp_codelens(client, bufnr)


  local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")
  if filetype == "rust" then
    require("user.utilities").register_rust_cargo_check_autocommand()
  end
  if filetype == "c" then
    -- require("user.utilities").register_gcc_check_autocommand()
    require("user.utilities").register_gcc_run_user_command()
  end
end

local capabilities = vim.lsp.protocol.make_client_capabilities()


local ok, nvim_status = pcall(require, "lsp-status")
if not ok then
  nvim_status = nil
end

if nvim_status then
  capabilities = vim.tbl_deep_extend("keep", capabilities, nvim_status.capabilities)
end


local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not status_ok then
  vim.notify("cmp_nvim_lsp not found. See LSP handler.lua")
  return
end

M.capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
return M
