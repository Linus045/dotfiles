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


  -- better highlightings and other useful features
  use({ "nvim-treesitter/nvim-treesitter",
    -- keep treesitter parsers up-to-date
    run = ":TSUpdate"
  })

  -- not sure if this is needed
  -- use("norcalli/nvim_utils")

  -- hook into formatters, code actions etc.
  use("jose-elias-alvarez/null-ls.nvim")



  ----------------------------- COLOR SCHEME -------------------------------
  -- use("jacoborus/tender.vim")
  -- use("folke/tokyonight.nvim")
  -- use("joshdick/onedark.vim")
  use("sainnhe/gruvbox-material")

  -- Line at the bottom showing useful information
  use("nvim-lualine/lualine.nvim")

  use({
    "nvim-lua/lsp-status.nvim",
    config = function()
      require("lsp-status").config({
        status_symbol = "❤ ",
      })
    end,
  })


  ----------------------------- PERFORMANCE -------------------------------
  -- cache plugins for faster startup
  use("lewis6991/impatient.nvim")


  ----------------------------- TEXT UTILS -------------------------------
  use({
    "chrisbra/unicode.vim",
    config = function()
      vim.g.Unicode_no_default_mappings = true
    end,
  })

  -- use("pierreglaser/folding-nvim")
  -- easier spell checking
  use("lewis6991/spellsitter.nvim")

  -- Automatically inserts brackets, etc. when needed
  use("windwp/nvim-autopairs")

  -- easier code navigation
  use("ggandor/lightspeed.nvim")

  -- Easily comment stuff
  use("numToStr/Comment.nvim")

  -- surround text easier (e.g. with ", {. <, etc.)
  use("tpope/vim-surround")

  -- split single line into multiple lines or vice versa
  use({
    "AndrewRadev/splitjoin.vim",
    config = function()
      vim.g.splitjoin_split_mapping = "g<Tab>"
      vim.g.splitjoin_join_mapping = "g<S-Tab>"
    end,
  })



  -------------------------- VISUAL EDITOR UTILS ---------------------------
  -- multi cursor
  use("mg979/vim-visual-multi")

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

  -- Colorize terminal color codes (when colored output is shown in nvim)
  use({
    "norcalli/nvim-terminal.lua",
    config = function()
      require("terminal").setup()
    end,
  })

  -- show line indentation
  --use "lukas-reineke/indent-blankline.nvim"

  -- bring current buffer in focus
  use("folke/zen-mode.nvim")





  ---------------- NVIM PROGRAMMING / PLUGIN TOOLING ------------------------
  -- nvim programming/ plugin tooling
  -- add lua ref into :help
  use("milisims/nvim-luaref")
  use("nanotee/luv-vimdocs")

  -- functions to help with debugging plugins
  use({
    "tpope/vim-scriptease",
    cmd = {
      "Messages", --view messages in quickfix list
      "Verbose", -- view verbose output in preview window.
      "Time", -- measure how long it takes to run some stuff.
    },
  })





  ----------------------------- AUTOCOMPLETE STUFF ---------------------------
  -- Copilot
  use("git@github.com:github/copilot.vim.git")

  -- Faster autocompletion
  use("hrsh7th/nvim-cmp")
  use("hrsh7th/cmp-nvim-lsp")
  use("hrsh7th/cmp-nvim-lsp-signature-help")
  use("hrsh7th/cmp-buffer")
  use("hrsh7th/cmp-path")
  use("hrsh7th/cmp-calc")
  use "hrsh7th/cmp-cmdline"
  use("hrsh7th/cmp-nvim-lua")
  use("hrsh7th/cmp-nvim-lsp-document-symbol")
  use("f3fora/cmp-spell")
  use("tamago324/cmp-zsh")

  -- show icons for entries in autocomplete menu
  use("onsails/lspkind.nvim")

  -- fix cmp ordering for dunder elements e.g. __main__ for python files
  use("lukas-reineke/cmp-under-comparator")

  -- snippet engine required by nvim-cmp
  use("L3MON4D3/LuaSnip")
  use("saadparwaiz1/cmp_luasnip")
  use("rafamadriz/friendly-snippets")


  -- Insert annotations for functions, classes, etc.
  use({
    "danymat/neogen",
    config = function()
      require("neogen").setup({
        snippet_engine = "luasnip",
      })
    end,
    requires = "nvim-treesitter/nvim-treesitter",
    -- Uncomment next line if you want to follow only stable versions
    -- tag = "*"
  })
  ----------------------------- LSP STUFF ---------------------------
  -- LSP server
  use("neovim/nvim-lspconfig")

  -- autoinstall lsp server
  use("williamboman/nvim-lsp-installer")

  use "lukas-reineke/lsp-format.nvim"









  ----------------------------- TELESCOPE ---------------------------
  -- telescope.
  use("nvim-telescope/telescope.nvim")

  -- fzf search for telescope
  use("nvim-telescope/telescope-fzf-native.nvim")


  -- telescope popup menu
  use("nvim-telescope/telescope-ui-select.nvim")



  ----------------------------- STARTUP STUFF -------------------------
  -- better nvim sessions
  -- run :Prosession to start a new session and run :Prosession again to load it on nvim restart
  use({
    "dhruvasagar/vim-prosession",
    requires = { "tpope/vim-obsession" },
    config = function()
      vim.g.prosession_tmux_title = true
      vim.g.prosession_on_startup = false
    end
  })

  -- add startscreen
  use({ "mhinz/vim-startify",
    config = function()
      vim.g.startify_custom_header = 'startify#pad(startify#fortune#boxed())'
    end })






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

  -- Shows current function scope/signature at the top of the screen
  use("nvim-treesitter/nvim-treesitter-context")

  -- generates method/function list for the current file
  -- use with :Vista
  use({ "liuchengxu/vista.vim", cmd = "Vista" })

  -- auto-resize focused window
  -- use({
  -- 	"beauwilliams/focus.nvim",
  -- 	config = function()
  -- 		require("focus").setup()
  -- 	end,
  -- })

  -- popup notification windows
  use("rcarriga/nvim-notify")

  -- show keyboard shortcuts
  use("folke/which-key.nvim")

  -- smooth scrolling (eg. using PageUp/PageDown)
  use("psliwka/vim-smoothie")

  -- better file explorer sidebar
  use("kyazdani42/nvim-tree.lua")

  -- shows undo/redo tree structure
  use("mbbill/undotree")

  -- floating terminal in nvim
  use("akinsho/toggleterm.nvim")

  -- git sings support on the sidebar
  use({ "lewis6991/gitsigns.nvim", requires = { "nvim-lua/plenary.nvim" } })

  -- allow transparent code
  use("xiyaowong/nvim-transparent")

  -- rainbow brackets
  use("p00f/nvim-ts-rainbow")


  -- -- If i ever use Sql
  -- tools to manage SQL stuff
  -- use("tpope/vim-dadbod")
  -- use({ "kristijanhusak/vim-dadbod-completion" })
  -- use({ "kristijanhusak/vim-dadbod-ui" })




  ----------------------------- GIT STUFF -------------------------
  -- lazygit for nvim
  --use "kdheepak/lazygit.nvim"

  -- git diff support
  use("sindrets/diffview.nvim")

  -- see git line info
  -- <leader>gm
  use("rhysd/git-messenger.vim")

  -- show more info when editing GITCOMMIT files, doesn't
  -- work with fugitive
  use("rhysd/committia.vim")

  -- git inside nvim
  use("TimUntersberger/neogit")
  use("tpope/vim-fugitive")

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




  ----------------------------- DEBUGGER -------------------------
  -- use { "puremourning/vimspector", run = "python3 install_gadget.py --enable-rust" }
  --  use "mfussenegger/nvim-dap"
  use("theHamsta/nvim-dap-virtual-text")
  use("nvim-telescope/telescope-dap.nvim")
  use({ "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap" } })

  -- debug the nvim client
  -- use "jbyuki/one-small-step-for-vimkind"



  ----------------------------- SPECIAL -------------------------
  -- Tetris
  -- :Tetris
  use("alec-gibson/nvim-tetris")

  -- use nvim in browser textedits (requires same browser plugin)
  use({
    "glacambre/firenvim",
    run = function()
      vim.fn["firenvim#install"](0)
    end,
  })

  -- open markdown preview
  -- " normal/insert
  -- <Plug>MarkdownPreview
  -- <Plug>MarkdownPreviewStop
  -- <Plug>MarkdownPreviewToggle
  use({
    "iamcco/markdown-preview.nvim",
    run = "cd app && npm install",
    setup = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
  })



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

  -- Latex plugins
  -- use("lervag/vimtex")

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
