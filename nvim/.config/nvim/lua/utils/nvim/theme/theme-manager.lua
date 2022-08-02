-- source: https://github.com/s1n7ax/dotnvim
local mytheme = require('utils.nvim.theme.theme_test')

local M = {}

function M.set_theme(theme)
    M.theme = theme
end

function M.get_theme()
    return M.theme or mytheme
end

return M
