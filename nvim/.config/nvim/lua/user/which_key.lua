vim.g.which_key_timeout = 1000

local status_ok, which_key = pcall(require, "whichkey_setup")
if not status_ok then
  vim.notify("whichkey_setup not found")
  return
end

which_key.config{
  hide_statusline = false,
  default_keymap_settings = {
    silent = true,
    noremap = true
  }
}

-- in case a custom keymap cannot be found, fallback to the default vim keybinding (e.g. gUU)
vim.g.which_key_fallback_to_native_key = true

local keymap = {
    -- w = {':w!<CR>', 'save file'}, -- set a single command and text
    -- j = 'split args', -- only set a text for an already configured keymap
    -- ['<CR>'] = {'@q', 'macro q'}, -- setting a special key
    f = { -- set a nested structure
        name = '+find',
        b = {'<Cmd>Telescope buffers<CR>', 'buffers'},
        h = {'<Cmd>Telescope help_tags<CR>', 'help tags'},
        c = {
            name = '+commands',
            c = {'<Cmd>Telescope commands<CR>', 'commands'},
            h = {'<Cmd>Telescope command_history<CR>', 'history'},
        },
        q = {'<Cmd>Telescope quickfix<CR>', 'quickfix'},
        g = {
            name = '+git',
            g = {'<Cmd>Telescope git_commits<CR>', 'commits'},
            c = {'<Cmd>Telescope git_bcommits<CR>', 'bcommits'},
            b = {'<Cmd>Telescope git_branches<CR>', 'branches'},
            s = {'<Cmd>Telescope git_status<CR>', 'status'},
        },
    }
}
which_key.register_keymap("leader", keymap)


local keymap_goto = {
  name = "+goto",
  r = { "<cmd>lua vim.lsp.bug.references()<CR>", "References" },
  -- d = { "<cmd>lua require'lspsaga.provider'.preview_definition()<CR>", "Peek Definition" },
  d = { "<cmd>lua vim.lsp.buf.definition()<CR>", "Goto Definition" },
  s = { "<cmd>lua vim.lsp.buf.signature_help()<CR>", "Signature Help" },
  i = { "<cmd>lua vim.lsp.buf.implementation()<CR>", "Goto Implementation" }
}

which_key.register_keymap("g", keymap_goto)
