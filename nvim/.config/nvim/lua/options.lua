-- Remap space as leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- disable netrw at the very start of your init.lua (strongly advised)
-- set for nvim-tree
-- comment these out temporarily if you need netrw enabled (e.g. to automatically download spell/dictionary files)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.g.termdebug_wide = 1
-- vim.g.termdebugger = "gdb"
vim.g.termdebugger = "rust-gdb"
-- vim.g.termdebug_useFloatingHover = 0

vim.opt.backup = false            -- creates a backup file
vim.opt.hidden = true             -- allow hidden buffers and don't unload them
vim.opt.clipboard = "unnamed"     -- allow neovim to access the system clipboard
vim.opt.cmdheight = 2             -- more space in the neovim command line for displaying messages
-- vim.opt.completeopt = { "menuone", "noselect" }      -- autocomplete in popup menu with default selection
vim.opt.conceallevel = 2          -- so that `` is visible in markdown files
vim.opt.fileencoding = "utf-8"    -- the encoding written to a file
vim.opt.hlsearch = true           -- hightlight all matches on previous search pattern
vim.opt.ignorecase = true         -- ignore case in search pattern
vim.opt.mouse = "a"               -- allow mouse to be used in neovim
-- vim.opt.pumheight = 20       -- pop up menu height
vim.opt.showmode = false          -- show/hide the current used mode e.g. -- INSERT --
vim.opt.showtabline = 2           -- always show tabs
vim.opt.smartcase = true          -- enables case sensitive search smartly (when an uppercase character is used)
vim.opt.smartindent = true        -- enables automatic smart indentation
vim.opt.splitbelow = true         -- force all horizontal splits to go below the current window
vim.opt.splitright = true         -- force all the vertical splits to go to the right of the window
vim.opt.swapfile = false          -- creates no swapfiles
vim.opt.termguicolors = true      -- set term gui colors (most terminals support this)
vim.opt.timeoutlen = 300          -- time to wait for a mapped sequence to complete (in milliseconds)
vim.opt.undofile = true           -- enable persistent undo
vim.opt.updatetime = 300          -- faster completion (4000ms default)
vim.opt.writebackup = false       -- if a file is being edited by another program (or was written to file with another program), it is NOT allowed to be edited
vim.opt.expandtab = false         -- converts tabs to spaces
vim.opt.shiftwidth = 4            -- the number of spaces inserted for each indentation
vim.opt.tabstop = 4               -- insert 2 spaces for a tab
vim.opt.cursorline = true         -- hightlight the current line
vim.opt.number = true             -- show numbered lines
vim.opt.relativenumber = true     -- set relative numbered lines
vim.opt.numberwidth = 4           -- set number column width
vim.opt.signcolumn = "yes"        -- always show the sign column, otherwise it would shift the text each time
vim.opt.wrap = false              -- DON'T wrap if lines get too long
vim.opt.scrolloff = 4             -- always keep 8 lines above and below the cursor (unless at the beginning/end of file)
vim.opt.inccommand = "nosplit"    -- Show substitutions in a preview buffer e.g. when using :%s/test/hello
vim.opt.guifont = "monospace:h17" -- set font
vim.opt.guicursor = "a:block-blinkoff0"
vim.opt.shortmess:append "c"      -- shorten messages
vim.opt.autochdir = false
vim.opt.spell = true              -- enable spell checking
vim.opt.spelllang = { "en", "de" }
vim.opt.spellsuggest = "best,10"

-- Adds directory to runtime path so we can access the spell directory
-- expands to /home/linus/.local/share/<nvim_profile>/site
-- https://github.com/folke/lazy.nvim/issues/64
vim.opt.rtp:append(vim.fn.stdpath("data") .. "/site")

vim.opt.colorcolumn = "80,100" -- color columns
vim.opt.foldlevel = 0          -- start with all folds open
vim.opt.foldlevelstart = 99
vim.opt.selection = "old"      -- prevents selecting of newline character in visual select mode
vim.opt.splitkeep = "screen"   -- changes how the cursor behaves on split

-- vim.g.transparent_enabled = true  -- disable transparent background

-- use / to represent deleted lines in diff mode (see: https://github.com/sindrets/diffview.nvim#tips-and-faq)
vim.opt.fillchars:append { diff = "/" }

-- Treesitter folding
vim.wo.foldmethod = 'expr' -- use treesitter folding
vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'
-- always use 3 columns to show folds
vim.wo.foldcolumn = '3'

vim.g.snippets = "luasnip"
vim.opt.list = true -- show specials characters for tab, end-of-line etc.


-- characters to show
vim.opt.listchars = {
	tab = "\\uf523 ",
	eol = "\\uebea",
	nbsp = "+"
}

if vim.fn.executable("rg") then
	vim.opt.grepprg = 'rg --vimgrep'
end

-- vim.cmd "set path+=**" -- bad practice see: https://github.com/tpope/vim-apathy
vim.cmd "set wildignore+=*/node_modules/*"
vim.cmd "set whichwrap+=<,>,[,]"         -- which keys wrap to the next line
vim.cmd "set backspace=indent,eol,start" -- allow backspacing over those
vim.cmd [[set iskeyword+=-]]             -- add - to be grouped as word
--vim.cmd [[set formatoptions-=c formatoptions-=r formatoptions-=o]]              -- edits the format options (no automatic comment character is inserted on ENTER) (Note: that using :set formatoptions-=cro won't work as expected (since it's a string))
vim.cmd [[au BufEnter * set fo-=c fo-=r fo-=o]]


-- change prosession directory
-- vim.g.prosession_dir = "~/.config/nvim/nvim_prosession/"


-- vim.cmd [[match errorMsg /\s\+$/]]
-- vim.cmd [[au BufEnter * highlight HIGHLIGHT_SPACES ctermbg=red guibg=red guifg=red]]
-- vim.cmd [[au BufEnter * match HIGHLIGHT_SPACES /\s\+$/]]

require("load_project_config").store_current_options()
