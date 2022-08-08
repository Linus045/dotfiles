_G.__luacache_config = {
  chunks = {
    enable = true,
    path = vim.fn.stdpath('cache')..'/luacache_chunks',
  },
  modpaths = {
    enable = true,
    path = vim.fn.stdpath('cache')..'/luacache_modpaths',
  }
}
require('impatient')

require("user.options")
require("user.keymaps")
-- require "user.vimspector"
require("user.plugins")
require("user.colorscheme")
--require "user.coq"
require("user.nvim-cmp")
-- require("user.luasnip")
require("user.lsp")
require("user.telescope")
require("user.treesitter")
require("user.neogit")
--require "user.catppuccin"
require("user.lualine")
require("user.todo-comments")
require("user.toggleterm")
require("user.gitsigns")
require("user.comment")
require("user.nvim-tree")
-- require("user.bufferline")
require("user.which_key_nvim")
require("user.lightspeed")
require("user.colorizer")
require("user.nvim-autopairs")
-- require "user.startup"
-- require "user.cheatsheet"
require("credentials.calendar_oauth_credentials")
require("user.calendar")
require("user.spellsitter")
-- require "user.shade_nvim"
require("user.zen_mode")
-- require "user.twilight"
require("user.nvim-transparent")
-- require "user.indent_blankline"
require("user.nvim_dap_ui")
require("user.dap_adapters")
require("user.nvim_dap_virtual_text")
-- require "user.latex"
require("user.notify")
require("user.utilities")
-- vim.cmd [[source ~/.config/nvim/lua/user/coc.vim]]
