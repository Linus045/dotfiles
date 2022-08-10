
-- David Zhang <https://github.com/crispgm>

--modified from https://github.com/crispgm/nvim-tabline/blob/main/lua/tabline.lua

local M = {}
local fn = vim.fn

M.options = {
    show_index = false,
    show_modify = true,
    modify_indicator = '[UNSAVED]',
    no_name = '[NO NAME]',
    default_colors = {
      TabLine = vim.api.nvim_get_hl_by_name("TabLine", true),
      TabLineSel = vim.api.nvim_get_hl_by_name("TabLineSel", true),
      TabLineFill = vim.api.nvim_get_hl_by_name("TabLineFill", true),
    },
    unsaved_colors = {
      TabLine = {
        -- foreground = "White",
        -- background = "Black"
      },
      TabLineSel = {
        -- foreground = "Black",
        background = "Red"
      },
      TabLineFill = {
        -- foreground = "Black",
        background = "Red"
      },
    }
}

          -- :hi TabLineFill guifg=LightGreen guibg=DarkGreen ctermfg=LightGreen ctermbg=DarkGreen
local function tabline(options)
    local s = ''
    for index = 1, fn.tabpagenr('$') do
        local winnr = fn.tabpagewinnr(index)
        local buflist = fn.tabpagebuflist(index)
        local bufnr = buflist[winnr]
        local bufname = fn.bufname(bufnr)
        local bufmodified = fn.getbufvar(bufnr, '&mod')

        s = s .. '%' .. index .. 'T'
        if index == fn.tabpagenr() then
            s = s .. '%#TabLineSel#'
        else
            s = s .. '%#TabLine#'
        end
        -- tab index
        s = s .. ' '
        -- index
        if options.show_index then
            s = s .. index .. ':'
        end

        -- buf name
        if bufname ~= '' then
            s = s .. fn.fnamemodify(bufname, ':p:~') .. ' '
        else
            s = s .. options.no_name .. ' '
        end

        -- modify indicator
        if bufmodified == 1 and options.show_modify and
          options.modify_indicator ~= nil then
          s = s .. options.modify_indicator .. ' '
        end

        if bufmodified == 1 then
          for hl_name, colors in pairs(M.options.unsaved_colors) do
            local fg_default = M.options.default_colors[hl_name].foreground
            local bg_default = M.options.default_colors[hl_name].background
            vim.api.nvim_set_hl(0, hl_name, {
              fg = colors.foreground or fg_default,
              bg = colors.background or bg_default,
            })
          end
        else
          -- local color_str = ""
          for hl_name, colors in pairs(M.options.default_colors) do
            -- color_str = color_str .. "Setting color: " .. hl_name .. " fg:" .. tostring(colors.foreground) .. " bg:" .. tostring(colors.background) .. "\n"
            if colors.foreground == nil or colors.background == nil then
              print("Colors background or foreground is nil")
            else
              vim.api.nvim_set_hl(0, hl_name, {
                fg = colors.foreground,
                bg = colors.background
              })
            end
          end
          -- print(color_str)
        end
    end

    s = s .. '%#TabLineFill#'
    return s
end

function M.setup(user_options)
    M.options = vim.tbl_extend('force', M.options, user_options)

    function _G.nvim_tabline()
        return tabline(M.options)
    end

    vim.o.showtabline = 2
    vim.o.tabline = '%!v:lua.nvim_tabline()'

    vim.g.loaded_nvim_tabline = 1
end

M.setup(M.options)


return M
