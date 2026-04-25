return {


	-- lazygit for nvim
	--use "kdheepak/lazygit.nvim"





	-- copy link to current line with <leader>gy into clipboard
	-- e.g. https://github.com/Linus045/dotfiles/blob/bccb860b05dcc3b5f4ee1e861ddb4cf661f3a522/nvim/.config/nvim/lua/user/plugins.lua#L249
	-- use({ "ruifm/gitlinker.nvim",
	--   config = function()
	--     require("gitlinker").setup()
	--   end
	-- })

	-- review git PRs directly in nvim (maybe use at some point)
	-- use {
	--   'pwntester/octo.nvim',
	--   requires = {
	--     'nvim-lua/plenary.nvim',
	--     'nvim-telescope/telescope.nvim',
	--     'kyazdani42/nvim-web-devicons',
	--   },
	--   config = function ()
	--     require"octo".setup()
	--   end
	-- }

	-- {
	-- 	"nvim-treesitter/nvim-treesitter-textobjects",
	-- 	branch = "main",
	-- 	after = "nvim-treesitter",
	-- 	requires = "nvim-treesitter/nvim-treesitter",
	-- 	init = function()
	-- 		vim.g.no_plugin_maps = true
	-- 	end,
	-- 	config = function()
	-- 		local config = require 'nvim-treesitter.config'
	-- 		config.setup {
	-- 		}
	-- 	end
	-- },


}
