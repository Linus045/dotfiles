local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
local first_install = false
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.notify("First start, setting up nvim...")
  first_install = true
end

require("user.plugins")

if first_install then
  return
end


-- _G.__luacache_config = {
--   chunks = {
--     enable = true,
--     path = vim.fn.stdpath('cache') .. '/luacache_chunks',
--   },
--   modpaths = {
--     enable = true,
--     path = vim.fn.stdpath('cache') .. '/luacache_modpaths',
--   }
-- }
-- local status_ok, impatient = pcall(require, 'impatient')
-- if not status_ok then
--   vim.notify("impatient not found")
-- end


require("user.utilities")

require("user.options")
require("user.keymaps")
-- require "user.vimspector"
require("user.colorscheme")
--require "user.coq"
require("user.nvim-cmp")
-- require("user.luasnip")
require("user.lsp")
require("user.mason_nvim")
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
require("user.tabline")
-- vim.cmd [[source ~/.config/nvim/lua/user/coc.vim]]
