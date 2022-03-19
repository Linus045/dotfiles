local status_ok, indent_blankline = pcall(require,"indent_blankline")
if not status_ok then
  vim.notify("indent_blankline not found")
  return
end

-- vim.opt.termguicolors = true -- already set in colorscheme.lua
vim.cmd [[highlight IndentBlanklineIndent1 guifg=#E06C75 gui=nocombine]]
vim.cmd [[highlight IndentBlanklineIndent2 guifg=#E5C07B gui=nocombine]]
vim.cmd [[highlight IndentBlanklineIndent3 guifg=#98C379 gui=nocombine]]
vim.cmd [[highlight IndentBlanklineIndent4 guifg=#56B6C2 gui=nocombine]]
vim.cmd [[highlight IndentBlanklineIndent5 guifg=#61AFEF gui=nocombine]]
vim.cmd [[highlight IndentBlanklineIndent6 guifg=#C678DD gui=nocombine]]

vim.opt.list = false -- show special characters
-- vim.opt.listchars:append("space:⋅")
vim.opt.listchars:append("eol:↴")

indent_blankline.setup {
  -- for example, context is off by default, use this to turn it on
  show_current_context = false,
  show_current_context_start = true,
  space_char_blankline = nil, --" ",
  indent_blankline_use_treesitter = true,  
  char_highlight_list = {
        "IndentBlanklineIndent1",
        "IndentBlanklineIndent2",
        "IndentBlanklineIndent3",
        "IndentBlanklineIndent4",
        "IndentBlanklineIndent5",
        "IndentBlanklineIndent6",
    },
}
