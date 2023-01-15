local notify = require("notify")

notify.setup({
  timeout = 1000,
  background_colour = "#000000",
  -- on_open = function(win)
  --   vim.api.nvim_win_set_config(win, { zindex = 2000, width = 4, height = 10 })
  --   local buf = vim.api.nvim_win_get_buf(win)
  --   vim.api.nvim_buf_set_option(buf, "wrap", true)
  -- end,
})

local old_notify = vim.notify

vim.notify = function(...)
  notify(...)
  old_notify(...)
end
