local status_ok, lualine = pcall(require, "lualine")
if not status_ok then
  vim.notify("lualine not found")
  return
end

lualine.setup {
  options = {
    icons_enabled = true,
    theme = 'gruvbox',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {},
    always_divide_middle = true,
  },
  sections = {
    -- lualine_a = {'mode'},
    -- lualine_b = {'branch', 'diff', 'diagnostics'},
    -- lualine_c = {'filename'},
    -- lualine_x = {'encoding', 'fileformat', 'filetype'},
    -- lualine_y = {'progress'},
    -- lualine_z = {'location'}
    lualine_a = {'mode'},
    lualine_b = {'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'diagnostics'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {
  },
  extensions = {}
}
