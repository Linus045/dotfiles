local notify = require("notify")

notify.setup({
  timeout = 1000,
  background_colour = "#000000",
  on_open = function(win)
    vim.api.nvim_win_set_config(win, { zindex = 2000 })
  end,
})

local old_notify = vim.notify

vim.notify = function(...)
  notify(...)
  old_notify(...)
end
