local ok, cybu = pcall(require, "cybu")
if not ok then
  vim.notify("cybu not found.")
  return
end

local keymap = require("user.utilities").keymap
if keymap == nil then
  vim.notify("File keymaps.lua: Can't setup keymaps, error loading user.cybu.lua")
  return
end

cybu.setup({
  position = {
    relative_to = "win", -- win, editor, cursor
    anchor = "topright", -- topleft, topcenter, topright,
    -- centerleft, center, centerright,
    -- bottomleft, bottomcenter, bottomright
    vertical_offset = 1, -- vertical offset from anchor in lines
    horizontal_offset = 1, -- vertical offset from anchor in columns
    max_win_height = 10, -- height of cybu window in lines
    max_win_width = 0.5, -- integer for absolute in columns
    -- float for relative to win/editor width
  },
  style = {
    path = "relative", -- absolute, relative, tail (filename only)
    border = "rounded", -- single, double, rounded, none
    hide_buffer_id = false, -- hide buffer IDs in window
  },
  behavior = { -- set behavior for different modes
    mode = {
      default = {
        switch = "immediate", -- immediate, on_close
        view = "rolling", -- paging, rolling
      },
      last_used = {
        switch = "on_close", -- immediate, on_close
        view = "rolling", -- paging, rolling
      },
    },
  },
  display_time = 750, -- time the cybu window is displayed

})


local opts = { noremap = true, silent = true }
keymap("n", "<M-S-TAB>", "<Plug>(CybuLastusedPrev)", opts, "[CYCLEBUFFER] Previous buffer", false, false)
keymap("n", "<M-TAB>", "<Plug>(CybuLastusedNext)", opts, "[CYCLEBUFFER] Next buffer", false, false)
keymap("v", "<M-S-TAB>", "<Plug>(CybuLastusedPrev)", opts, "[CYCLEBUFFER] Previous buffer", false, false)
keymap("v", "<M-TAB>", "<Plug>(CybuLastusedNext)", opts, "[CYCLEBUFFER] Next buffer", false, false)

keymap("n", "<S-TAB>", "<Plug>(CybuLastusedPrev)", opts, "[CYCLEBUFFER] Previous buffer", false, false)
keymap("n", "<TAB>", "<Plug>(CybuLastusedNext)", opts, "[CYCLEBUFFER] Next buffer", false, false)
keymap("v", "<S-TAB>", "<Plug>(CybuLastusedPrev)", opts, "[CYCLEBUFFER] Previous buffer", false, false)
keymap("v", "<TAB>", "<Plug>(CybuLastusedNext)", opts, "[CYCLEBUFFER] Next buffer", false, false)
