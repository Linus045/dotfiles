local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system {
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  }
  print "Installing packer close and reopen Neovim..."
  vim.cmd [[packadd packer.nvim]]
end


-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]


-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end


-- Have packer use a popup window
packer.init {
  display = {
    open_fn = function()
      return require("packer.util").float { border = "rounded" }
    end,
  },
}


-- Install your plugins here
return packer.startup(function(use)
  -- My plugins here
  use "wbthomason/packer.nvim" -- Have packer manage itself
  use "nvim-lua/plenary.nvim" -- Useful lua functions used ny lots of plugins
  use "nvim-lua/popup.nvim" -- An implementation of the Popup API from vim in Neovim
  use "kyazdani42/nvim-web-devicons" -- Icons needed by a few plugins (lualine, etc.)

  -- Color scheme
  use "jacoborus/tender.vim"
  use "folke/tokyonight.nvim"
  use "joshdick/onedark.vim"
  use "sainnhe/gruvbox-material"

  use {
    "nvim-lualine/lualine.nvim",
    requires = { "kyazdani42/nvim-web-devicons", opt = true }
  }

  -- Buffer line above
  use {'akinsho/bufferline.nvim', requires = 'kyazdani42/nvim-web-devicons'}
  use "kdheepak/lazygit.nvim"

  use "folke/which-key.nvim"

  use "ms-jpq/coq_nvim"
  use "ms-jpq/coq.artifacts"
  use "ms-jpq/coq.thirdparty"

  use "neovim/nvim-lspconfig"
  use "williamboman/nvim-lsp-installer"

  use "nvim-telescope/telescope.nvim"
  use "nvim-treesitter/nvim-treesitter"
  use "nvim-telescope/telescope-fzf-native.nvim"

  use {
    'sudormrfbin/cheatsheet.nvim',

    requires = {
      {'nvim-telescope/telescope.nvim'},
      {'nvim-lua/popup.nvim'},
      {'nvim-lua/plenary.nvim'},
    }
  }

  use 'kyazdani42/nvim-tree.lua'

  use "akinsho/toggleterm.nvim"
-- hightlight keywods:
-- TODO:
-- BUG:
-- HACK:
-- BUG:
-- PERF:
-- NOTE:
-- WARNING:
  use "folke/todo-comments.nvim"
  -- Colorize color codes
  use "norcalli/nvim-colorizer.lua"

  -- git diff support
  use "sindrets/diffview.nvim"
  use "TimUntersberger/neogit"

  -- git sings support
  use {'lewis6991/gitsigns.nvim', requires = { 'nvim-lua/plenary.nvim' }}

  use 'ggandor/lightspeed.nvim'

  --Start screen
  use { "startup-nvim/startup.nvim", requires = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }}

  -- Easily comment stuff
  use "numToStr/Comment.nvim"
  -- Treesitter context dependant comments
  use 'JoosepAlviste/nvim-ts-context-commentstring'


  use "p00f/nvim-ts-rainbow"

  use { "puremourning/vimspector", run = "python3 install_gadget.py --enable-rust" }

  use "itchyny/calendar.vim"
  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
