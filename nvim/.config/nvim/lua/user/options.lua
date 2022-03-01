vim.opt.backup = false                          -- creates a backup file
vim.opt.hidden = true                           -- allow hidden buffers and don't unload them
vim.opt.clipboard = "unnamedplus"               -- allow neovim to access the system clipboard
vim.opt.cmdheight = 2                           -- more space in the neovim command line for displaying messages
vim.opt.completeopt = { "menuone", "noselect"}  -- autocomplete in popup menu with default selection
vim.opt.conceallevel = 0                        -- so that `` is visible in markdown files
vim.opt.fileencoding = "utf-8"                  -- the encoding written to a file
vim.opt.hlsearch = true                         -- hightlight all matches on previous search pattern
vim.opt.ignorecase = true                       -- ignore case in search pattern
vim.opt.mouse = "a"                             -- allow mouse to be used in neovim
vim.opt.pumheight = 20                          -- pop up menu height
vim.opt.showmode = true                         -- show/hide the current used mode e.g. -- INSERT --
vim.opt.showtabline = 2                         -- always show tabs
vim.opt.smartcase = true                        -- enables case sensitive search smartly (when an uppercase character is used)
vim.opt.smartindent = true                      -- enables automatic smart indentation
vim.opt.splitbelow = true                       -- force all horizontal splits to go below the current window
vim.opt.splitright = true                       -- force all the vertical splits to go to the right of the window
vim.opt.swapfile = false                        -- creates no swapfiles
-- vim.opt.termguicolors = true                    -- set term gui colors (most terminals support this)
vim.opt.timeoutlen = 1000                       -- time to wait for a mapped sequence to complete (in milliseconds)
vim.opt.undofile = true                         -- enable persistent undo
vim.opt.updatetime = 300                        -- faster completion (4000ms default)
vim.opt.writebackup = false                     -- if a file is being edited by another program (or was written to file with another program), it is NOT allowed to be edited
vim.opt.expandtab = true                        -- converts tabs to spaces
vim.opt.shiftwidth = 2                          -- the number of spaces inserted for each indentation
vim.opt.tabstop = 2                             -- insert 2 spaces for a tab
vim.opt.cursorline = true                       -- hightlight the current line
vim.opt.number = true                           -- show numbered lines
vim.opt.relativenumber = false                  -- set relative numbered lines
vim.opt.numberwidth = 4                         -- set number column width
vim.opt.signcolumn = "yes"                      -- always show the sign column, otherwise it would shift the text each time
vim.opt.wrap = false                            -- DON'T wrap if lines get too long
vim.opt.scrolloff = 8                           -- always keep 8 lines above and below the cursor (unless at the beginning/end of file)
vim.opt.guifont = "monospace:h17"               -- set font
vim.opt.shortmess:append "c"                    -- shorten messages
vim.opt.autochdir = false

vim.cmd "set whichwrap+=<,>,[,]"                -- which keys wrap to the next line
vim.cmd "set backspace=indent,eol,start"        -- allow backspacing over those
vim.cmd [[set iskeyword+=-]]                    -- add - to be grouped as word
--vim.cmd [[set formatoptions-=c formatoptions-=r formatoptions-=o]]              -- edits the format options (no automatic comment character is inserted on ENTER) (Note: that using :set formatoptions-=cro won't work as expected (since it's a string))
vim.cmd [[au BufEnter * set fo-=c fo-=r fo-=o]]

