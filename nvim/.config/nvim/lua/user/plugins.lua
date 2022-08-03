local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	PACKER_BOOTSTRAP = fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
	print("Installing packer close and reopen Neovim...")
	vim.cmd([[packadd packer.nvim]])
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
	return
end

-- Have packer use a popup window
packer.init({
	display = {
		open_fn = function()
			return require("packer.util").float({ border = "rounded" })
		end,
	},
})

-- Install your plugins here
return packer.startup(function(use)
	-- My plugins here
	use("wbthomason/packer.nvim") -- Have packer manage itself
	use("nvim-lua/plenary.nvim") -- Useful lua functions used ny lots of plugins
	use("nvim-lua/popup.nvim") -- An implementation of the Popup API from vim in Neovim
	use("kyazdani42/nvim-web-devicons") -- Icons needed by a few plugins (lualine, etc.)

	-- Color scheme
	use("jacoborus/tender.vim")
	use("folke/tokyonight.nvim")
	use("joshdick/onedark.vim")
	use("sainnhe/gruvbox-material")

	-- Line at the bottom showing useful information
	use({
		"nvim-lualine/lualine.nvim",
		requires = { "kyazdani42/nvim-web-devicons", opt = true },
	})

	-- Buffer line above showing buffers and tabs
	use({ "akinsho/bufferline.nvim", requires = "kyazdani42/nvim-web-devicons" })

	-- lazygit for nvim
	--use "kdheepak/lazygit.nvim"

	-- popup notification windows
	use("rcarriga/nvim-notify")

	-- show keyboard shortcuts
	use("folke/which-key.nvim")

	-- easier spell checking
	use("lewis6991/spellsitter.nvim")

	-- snippet engine required by nvim-cmp
	use("L3MON4D3/LuaSnip")
	-- Faster autocompletion
	use("hrsh7th/nvim-cmp")
	use("hrsh7th/cmp-nvim-lsp")
	use("hrsh7th/cmp-nvim-lsp-signature-help")
	use("hrsh7th/cmp-buffer")
	use("hrsh7th/cmp-path")
	use("hrsh7th/cmp-calc")
	use("f3fora/cmp-spell")

	-- hook into formatters, code actions etc.
	use("jose-elias-alvarez/null-ls.nvim")

	-- smooth scrolling (eg. using PageUp/PageDown)
	use("psliwka/vim-smoothie")

	-- auto-resize focused window
	use({
		"beauwilliams/focus.nvim",
		config = function()
			require("focus").setup()
		end,
	})

	use("nvim-treesitter/nvim-treesitter-context")

	-- LSP server
	use("neovim/nvim-lspconfig")
	-- autoinstall lsp server
	use("williamboman/nvim-lsp-installer")

	-- telescope.
	use("nvim-telescope/telescope.nvim")

	-- better highlightings and other useful features
	use("nvim-treesitter/nvim-treesitter")

	-- fzf search for telescope
	use("nvim-telescope/telescope-fzf-native.nvim")

	use("git@github.com:github/copilot.vim.git")

	use("norcalli/nvim_utils")

	-- show keyboard shortcuts in a searchable menu (similar to :Telescope keymaps)
	-- use {
	--   'sudormrfbin/cheatsheet.nvim',

	--   requires = {
	--     {'nvim-telescope/telescope.nvim'},
	--     {'nvim-lua/popup.nvim'},
	--     {'nvim-lua/plenary.nvim'},
	--   }

	-- better nvim sessions
	-- run :Prosession to start a new session and run :Prosession again to load it on nvim restart
	use({
		"dhruvasagar/vim-prosession",
		requires = { "tpope/vim-obsession" },
	})

	-- multi cursor
	use("mg979/vim-visual-multi")

	-- better file explorer sidebar
	use("kyazdani42/nvim-tree.lua")

	-- shows undo/redo tree structure
	use("mbbill/undotree")

	-- floating terminal in nvim
	use("akinsho/toggleterm.nvim")

	-- hightlight keywods:
	-- TODO:
	-- BUG:
	-- HACK:
	-- BUG:
	-- PERF:
	-- NOTE:
	-- WARNING:
	use("folke/todo-comments.nvim")

	-- Colorize color codes e.g. #222266
	use("norcalli/nvim-colorizer.lua")

	-- show line indentation
	--use "lukas-reineke/indent-blankline.nvim"

	-- git diff support
	use("sindrets/diffview.nvim")

	-- git inside nvim
	use("TimUntersberger/neogit")

	-- git sings support on the sidebar
	use({ "lewis6991/gitsigns.nvim", requires = { "nvim-lua/plenary.nvim" } })

	-- easier code navigation
	use("ggandor/lightspeed.nvim")

	-- JS Formatter
	--use 'maksimr/vim-jsbeautify'

	--Start screen
	-- use { "startup-nvim/startup.nvim", requires = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }}

	-- Easily comment stuff
	use("numToStr/Comment.nvim")
	-- Treesitter context dependant comments
	--use 'JoosepAlviste/nvim-ts-context-commentstring'

	-- only highlight the current scope/surrounding lines
	--use "folke/twilight.nvim"

	-- bring current buffer in focus
	use("folke/zen-mode.nvim")

	-- allow transparent code
	use("xiyaowong/nvim-transparent")
	-- gray out not focused panels (kinda buggy atm)
	-- use 'sunjon/shade.nvim'

	use("p00f/nvim-ts-rainbow")

	-- surround text easier (e.g. with ", {. <, etc.)
	use("tpope/vim-surround")
	-- debugger
	-- use { "puremourning/vimspector", run = "python3 install_gadget.py --enable-rust" }
	--  use "mfussenegger/nvim-dap"
	use("theHamsta/nvim-dap-virtual-text")
	use("nvim-telescope/telescope-dap.nvim")
	use({ "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap" } })
	-- show calender (synched with google)
	use("itchyny/calendar.vim")

	-- Latex plugins
	use("lervag/vimtex")

	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)
