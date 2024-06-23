return {


	-- lazygit for nvim
	--use "kdheepak/lazygit.nvim"

	-- git diff support
	{
		"sindrets/diffview.nvim",
		config = function()
			local actions = require("diffview.actions")
			require("diffview").setup({
				enhanced_diff_hl = true, -- See ':h diffview-config-enhanced_diff_hl',
				keymaps = {
					view = {
						{ "n", "<leader>e", actions.toggle_files, { desc = "Toggle the file panel." } },
					},
					file_panel = {
						{ "n", "s", actions.toggle_stage_entry, { desc = "Stage / unstage the selected entry" } },
						{ "n", "u", actions.toggle_stage_entry, { desc = "Stage / unstage the selected entry" } },
					},
				},
			})
		end
	},

	-- see git line info
	-- <leader>gm
	{
		"rhysd/git-messenger.vim",
		config = function()
			vim.g.git_messenger_always_into_popup = true
			vim.g.git_messenger_no_default_mappings = true
		end
	},

	-- show more info when editing GITCOMMIT files, doesn't
	-- work with fugitive
	"rhysd/committia.vim",

	-- git inside nvim
	{
		"TimUntersberger/neogit",
		branch = "master",
		config = function()
			require("neogit").setup({})
		end
	},

	{
		"ThePrimeagen/git-worktree.nvim",
		config = function()
			require("git-worktree").setup()
		end

	},

	-- Useful short videos of how to use fugitive:
	-- Links taken from: https://github.com/tpope/vim-fugitive#screencasts
	-- 	## Screencasts
	-- * [A complement to command line git](http://vimcasts.org/e/31)
	-- * [Working with the git index](http://vimcasts.org/e/32)
	-- * [Resolving merge conflicts with vimdiff](http://vimcasts.org/e/33)
	-- * [Browsing the git object database](http://vimcasts.org/e/34)
	-- * [Exploring the history of a git repository](http://vimcasts.org/e/35)
	{
		"tpope/vim-fugitive",
		config = function()
			-- remap '=' to '<TAB>' so I can toggle the diff more easily
			vim.cmd([[ let g:nremap = {'=': '<TAB>'}]])
		end
	},

	-- Github integration for fugitive (e.g. :Gbrowse)
	"tpope/vim-rhubarb",

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


}
