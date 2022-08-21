local ThemeManager = require("utils.nvim.theme.theme-manager")
local HighlightGroups = require("utils.nvim.highlighting.highlight-groups")
local highlighter = require("utils.nvim.highlighting.highlighter")

local theme = ThemeManager.get_theme()

local highlight_groups = HighlightGroups({
  TextYank = { guibg = theme.normal.yellow, guifg = theme.normal.black },
})

highlighter:new():add(highlight_groups):register_highlights()

vim.cmd("autocmd TextYankPost * silent! lua vim.highlight.on_yank {higroup=(vim.fn['hlexists']('HighlightedyankRegion') > 0 and 'HighlightedyankRegion' or 'IncSearch'), timeout=300}")



-- e.g. :lua P(vim.api)
-- now also :lua =vim.api works
function P(v)
  print(vim.inspect(v))
  return v
end

local status_ok, wk = pcall(require, 'which-key')
if not status_ok then
  vim.notify('File utilities.lua: which-key not found.')
  return
end

local M = {}
M.bindings = {
  n = {},
  i = {},
  v = {},
  x = {},
  t = {}
}

M.keymap = function(mode, lhs, rhs, opts, description, dontShow, dontRegister)
  if not M.bindings[mode] then
    vim.notify("Error: invalid mode (" .. mode .. ") for keybinding: " .. lhs .. " = " .. rhs)
    return
  end

  if M.bindings[mode][lhs] ~= nil then
    vim.notify("Conflicting keybinding for: " .. lhs)
    return
  end

  M.bindings[mode][lhs] = {
    ["mode"] = mode,
    ["lhs"] = lhs,
    ["rhs"] = rhs,
    ["opts"] = opts
  }
  local mapping = {
    [lhs] = { rhs }
  }

  -- hide binding in popup
  if dontShow then
    mapping[lhs][1] = "which_key_ignore"
  end

  if description ~= nil then
    table.insert(mapping[lhs], description)
  end

  --P({ mode, mapping })

  wk.register(mapping, {
    ["mode"] = mode, -- NORMAL mode
    -- prefix: use "<leader>f" for example for mapping everything related to finding files
    -- the prefix is prepended to every mapping part of `mappings`
    buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
    silent = true, -- use `silent` when creating keymaps
    noremap = true, -- use `noremap` when creating keymaps
    nowait = false, -- use `nowait` when creating keymaps
  })

  if not dontRegister then
    vim.api.nvim_set_keymap(mode, lhs, rhs, opts)
  end
end

return M
