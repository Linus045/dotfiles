  --------------------- needed for other packages ------------------------------
  -- Useful lua functions used ny lots of plugins
  use("nvim-lua/plenary.nvim")

  -- An implementation of the Popup API from vim in Neovim
  use("nvim-lua/popup.nvim")

  -- Icons needed by a few plugins (lualine, etc.)
  use("kyazdani42/nvim-web-devicons")

  -- local icons = require "nvim-nonicons"
  -- icons.get("file")
  -- TestIcon: 
  -- requires to register the font shown in the 'dist' directory
  -- then set that font as fallback for the icons in the kitty.conf file
  -- use {
  --   'yamatsum/nvim-nonicons',
  --   requires = {'kyazdani42/nvim-web-devicons'}
  -- }
  -- use "yamatsum/nvim-web-nonicons"


  -- Line at the bottom showing useful information
  use()

  -- LSP loading in a small hover text in the bottom right corner


  ----------------------------- PERFORMANCE -------------------------------
  -- cache plugins for faster startup
  -- use("lewis6991/impatient.nvim")


  ----------------------------- TEXT UTILS -------------------------------
  use({
    "chrisbra/unicode.vim",
    config = function()
      if first_install then return end
      vim.g.Unicode_no_default_mappings = true
    end,
  })

  -- automatically creates folds (use zc to close and zo to open a fold)
  -- use("pierreglaser/folding-nvim")
  -- easier spell checking
  use("lewis6991/spellsitter.nvim")


  -------------------------- VISUAL EDITOR UTILS ---------------------------

  -- show line indentation
  --use "lukas-reineke/indent-blankline.nvim"

  -- use("powerman/vim-plugin-AnsiEsc")


  -- buffer list navigation similar to Ctrl+Tab in browsers
  -- use("ghillb/cybu.nvim")







  ----------------------------- AUTOCOMPLETE STUFF ---------------------------





  ----------------------------- LSP STUFF ---------------------------

  ----------------------------- TELESCOPE ---------------------------



  ----------------------------- STARTUP STUFF -------------------------




  ----------------------------- NVIM INTERFACE STUFF -------------------------
  -- Buffer line above showing buffers and tabs
  -- use({ "akinsho/bufferline.nvim", requires = "kyazdani42/nvim-web-devicons" })

  -- show keyboard shortcuts in a searchable menu (similar to :Telescope keymaps)
  -- use {
  --   'sudormrfbin/cheatsheet.nvim',

  --   requires = {
  --     {'nvim-telescope/telescope.nvim'},
  --     {'nvim-lua/popup.nvim'},
  --     {'nvim-lua/plenary.nvim'},
  --   }




  -- auto-resize focused window
  -- use({
  -- 	"beauwilliams/focus.nvim",
  -- 	config = function()
  -- 		require("focus").setup()
  -- 	end,
  -- })




  ----------------------------- GIT STUFF -------------------------

  ----------------------------- DEBUGGER -------------------------

  ----------------------------- SPECIAL -------------------------


  ----------------------------- DISABLED -------------------------

  --Start screen
  -- use { "startup-nvim/startup.nvim", requires = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }}

  -- Treesitter context dependant comments
  --use 'JoosepAlviste/nvim-ts-context-commentstring'

  -- only highlight the current scope/surrounding lines
  --use "folke/twilight.nvim"

  -- gray out not focused panels (kinda buggy atm)
  -- use 'sunjon/shade.nvim'

  -- python support
  -- use "mfussenegger/nvim-dap-python"


  -- show calender (synched with google)
  -- use("itchyny/calendar.vim")


  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)


