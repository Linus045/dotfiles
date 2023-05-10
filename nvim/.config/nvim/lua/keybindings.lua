local keymap = require("keybindings_util").keymap

local opts = { noremap = true, silent = true }
local term_opts = { silent = true }

-- no mapping to apply to all. see :help map-modes
keymap("", "<Space>", "<Nop>", opts)

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c"

-- Normal --
-- Better window navigation
-- keymap("n", "<C-h>", "<C-w>h", opts)
-- keymap("n", "<C-j>", "<C-w>j", opts)
-- keymap("n", "<C-k>", "<C-w>k", opts)
-- keymap("n", "<C-l>", "<C-w>l", opts)

-- Replaced with nvim-tree
--keymap("n", "<leader>e", ":Lexplore 20<cr>", opts)
keymap("n", "<leader>e", ":NvimTreeToggle<cr>", opts, "NVIM Tree")

-- show legendary.nvim palette
keymap("n", "<leader>p", ":Legendary<cr>", opts, "Open Legendary Command Palette")

-- Resize with arrows
keymap("n", "<C-Up>", ":resize +2<cr>", opts, "Resize up")
keymap("n", "<C-Down>", ":resize -2<CR>", opts, "Resize down")
keymap("n", "<C-Left>", ":vertical resize +2<CR>", opts, "Resize left")
keymap("n", "<C-Right>", ":vertical resize -2<CR>", opts, "Resize right")


-- Navigate buffers
-- keymap("n", "<S-l>", ":bnext<CR>", opts)
-- keymap("n", "<S-h>", ":bprevious<CR>", opts)

-- Insert --
-- Press jk fast to escape
keymap("i", "jk", "<ESC>", opts, nil, true)

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", opts, nil, true)
keymap("v", ">", ">gv", opts, nil, true)


-- Move text up and down
keymap("n", "<A-k>", "<Esc>:m .-2<CR>", opts, nil, true)
keymap("n", "<A-j>", "<Esc>:m .+1<CR>", opts, nil, true)
keymap("v", "<A-j>", ":m .+1<CR>", opts, nil, true)
keymap("v", "<A-k>", ":m .-2<CR>", opts, nil, true)
-- when pasting, don't override the register
--keymap("v", "<leader>p", '"_dP', opts, "Better Paste (won't override the register)")
keymap("x", "p", '"_dP', opts, nil, true)

keymap("n", "<leader>y", '"+y', opts, "Copy to system clipboard")
keymap("v", "<leader>y", '"+y', opts, "Copy to system clipboard")

-- Visual Block --
-- Move text up and down
keymap("x", "J", ":move '>+1<CR>gv-gv", opts, nil, true)
keymap("x", "K", ":move '<-2<CR>gv-gv", opts, nil, true)
keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", opts, nil, true)
keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", opts, nil, true)

-- Terminal --
-- Better terminal navigation
keymap("t", "<C-h>", "<C-\\><C-N><C-w>h", term_opts, nil, true)
keymap("t", "<C-j>", "<C-\\><C-N><C-w>j", term_opts, nil, true)
keymap("t", "<C-k>", "<C-\\><C-N><C-w>k", term_opts, nil, true)
keymap("t", "<C-l>", "<C-\\><C-N><C-w>l", term_opts, nil, true)

-- open terminal in split
keymap("n", "<leader>tv", ":vsplit | term<cr>:vertical resize 90<cr>i", opts, "Open Terminal VERTICAL")
keymap("n", "<leader>th", ":split | term<cr>:resize 15<cr>i", opts, "Open Terminal Horizontal")
keymap("n", "<leader>x", ":bw<cr>", opts, "Kill window")
keymap("n", "<leader>X", ":bw!<cr>", opts, "Kill window (forced)")

--keymap("n", "<leader>f", "<cmd>Telescope find_files<CR>", opts)
keymap("n", "<leader>f", nil, opts, "[FINDER]", false, true)
keymap("n", "<leader>ff", "<cmd>Telescope find_files<CR>", opts, "Telescope find_files")
keymap("n", "<leader>fg", "<cmd>Telescope git_files<CR>", opts, "Telescope git_files")
keymap("n", "<leader>fb", "<cmd>Telescope buffers<CR>", opts, "Telescope buffers")
keymap("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", opts, "Telescope help tags")
keymap("n", "<leader>fc", "<cmd>Telescope commands<CR>", opts, "Telescope commands")
keymap("n", "<leader>fd", "<cmd>Telescope diagnostics<CR>", opts, "Telescope diagnostics")

keymap("n", "<leader>fs", nil, opts, "[LSP Symbols]", false, true)
keymap("n", "<leader>fss", "<cmd>Telescope lsp_document_symbols<CR>", opts, "Telescope workspace symbols")
keymap("n", "<leader>fsw", "<cmd>Telescope lsp_workspace_symbols<CR>", opts, "Telescope workspace symbols")
keymap("n", "<leader>fsd", "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>", opts, "Telescope workspace symbols")
keymap("n", "<leader>?", "<cmd>Telescope keymaps<CR>", opts, "Telescope keymaps")

-- default Live Grep
keymap("n", "<leader>g", nil, opts, "[GREP|Codelens]", false, true)
-- Live Grep with regular Expression (default rg)
keymap("n", "<leader>ge", "<cmd>Telescope live_grep<CR>", opts, "Telescope live_grep (with RegEx)")
-- Live Grep with hidden hiles
keymap("n", "<leader>gh",
	"<cmd>lua require'telescope.builtin'.live_grep({vimgrep_arguments={'rg', '--color=never', '--no-heading', '--with-filename', '--line-number', '--column', '--smart-case', '--hidden', '--trim'}})<cr>"
	, opts, "Telescope live_grep (with hidden files)"
)

-- Live Grep without regular Expression
keymap("n", "<leader>gg",
	"<cmd>lua require'telescope.builtin'.live_grep({vimgrep_arguments={'rg','--color=never','--no-heading','--with-filename','--line-number','--column','--smart-case','--fixed-strings', '--trim'}})<cr>"
	,
	opts,
	"Telescope live_grep (without RegEx)")

keymap("n", "<leader>gs",
	[[<cmd>lua require 'telescope.builtin'.grep_string({ search = vim.fn.input('GREP>'), vimgrep_arguments ={ 'rg', '--color=never', '--no-heading', '--with-filename', '--line-number', '--column', '--smart-case', '--fixed-strings', '--trim'} }) <CR>]],
	opts,
	"Telescope grep_string")

keymap("n", "<leader>gl",
	[[<cmd>lua require'plugins.telescope.telescope_custom'.live_grep_in_glob() <CR>]],
	opts,
	"Telescope live_grep_in_glob")

keymap(
	"n",
	"<leader>0",
	"<cmd>lua require'plugins.telescope.telescope_custom'.dot_files()<CR>",
	opts,
	"Telescope find_files (Dotfiles)"
)

keymap(
	"n",
	"<leader>9",
	"<CMD>:e ~/.nvim_journal/.nvim_journal.md<CR>",
	opts,
	"Open NvimJournal"
)

keymap(
	"n",
	"<leader>8",
	"<CMD>lua require'plugins.telescope.telescope_custom'.list_sessions()<CR>",
	opts,
	"Prosessions List"
)

keymap("n", "<leader>s", "<cmd>lua require'telescope.builtin'.current_buffer_fuzzy_find()<cr>", opts,
	"Telescope Fuzzy Buffer")

-- keymap("n", "<leader>s", "<cmd>lua require'telescope.builtin'.lsp_workspace_symbols()<cr>", opts)
keymap("n", "<leader>.", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts, "Code Actions")
keymap("v", "<leader>.", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts, "Code Actions")
-- remap to open the Telescope refactoring menu in visual mode

keymap("n", "<leader>r", nil, opts, "[REFACTOR|RENAME]", false, true)
keymap("v", "<leader>r", nil, opts, "[REFACTOR|RENAME]", false, true)
keymap("n", "<leader>rr", "<Esc><cmd>lua require('telescope').extensions.refactoring.refactors()<CR>", { noremap = true }
, "Refactor [Telescope]")
keymap("v", "<leader>rr", "<Esc><cmd>lua require('telescope').extensions.refactoring.refactors()<CR>", { noremap = true }
, "Refactor [Telescope]")


keymap("n", "<leader>dld", "<cmd>lua require'telescope.builtin'.diagnostics()<cr>", opts, "Telescope diagnostics")

-- Telescope DAP
keymap("n", "<leader>d", nil, opts, "[DEBUG]", false, true)
keymap("v", "<leader>d", nil, opts, "[DEBUG]", false, true)
keymap("n", "<leader>di", nil, opts, "[INSPECT]", false, true)
keymap("v", "<leader>di", nil, opts, "[INSPECT]", false, true)
keymap("n", "<leader>dl", nil, opts, "[DEBUG] Lists Breakpoints, Variables, Frames...", false, true)
keymap("n", "<leader>dlb", ":Telescope dap list_breakpoints<CR>", opts, "List breakpoints")
keymap("n", "<leader>dlc", ":Telescope dap configurations<CR>", opts, "List configurations")
keymap("n", "<leader>dlx", ":Telescope dap commands<CR>", opts, "List commands")
keymap("n", "<leader>dlv", ":Telescope dap variables<CR>", opts, "List variables")
keymap("n", "<leader>dlf", ":Telescope dap frames<CR>", opts, "List frames")

keymap("n", "<F10>", function()
	local filetype = vim.api.nvim_buf_get_option(0, "filetype")
	if filetype == "rust" then
		if require("termdebug_helper").in_debug_session then
			vim.cmd("Over")
		else
			vim.notify("No Termdebug session running.")
		end
	else
		require 'dap'.step_over()
	end
end, opts, "[DEBUG] Step Over")

keymap("n", "<F5>", function()
	local filetype = vim.api.nvim_buf_get_option(0, "filetype")
	if filetype == "rust" then
		if require("termdebug_helper").in_debug_session then
			vim.cmd("Continue")
		else
			require("termdebug_helper").RunDebugAndBreak()
		end
	else
		require 'dap'.my_custom_continue_function()
	end
end, opts, "[DEBUG] Continue / Run and break at current line")


keymap("n", "<F11>", function()
	local filetype = vim.api.nvim_buf_get_option(0, "filetype")
	if filetype == "rust" then
		if require("termdebug_helper").in_debug_session then
			vim.cmd("Step")
		else
			vim.notify("No Termdebug session running.")
		end
	else
		require 'dap'.step_into()
	end
end, opts, "[DEBUG] Step Into")


keymap("n", "<F12>", function()
	local filetype = vim.api.nvim_buf_get_option(0, "filetype")
	if filetype == "rust" then
		if require("termdebug_helper").in_debug_session then
			vim.cmd("Finish")
		else
			vim.notify("No Termdebug session running.")
		end
	else
		require 'dap'.step_out()
	end
end, opts, "[DEBUG] Step Out")

keymap("n", "<leader>db", function()
	local filetype = vim.api.nvim_buf_get_option(0, "filetype")
	if filetype == "rust" then
		if require("termdebug_helper").in_debug_session then
			vim.cmd("Break")
		else
			vim.notify("No Termdebug session running.")
		end
	else
		require 'dap'.toggle_breakpoint()
	end
end, opts, "[DEBUG] Toggle Breakpoint")

keymap("n", "<leader>dd", function()
	local filetype = vim.api.nvim_buf_get_option(0, "filetype")
	if filetype == "rust" then
		if require("termdebug_helper").in_debug_session then
			vim.cmd("Clear")
		else
			vim.notify("No Termdebug session running.")
		end
	else
		require 'dap'.toggle_breakpoint()
	end
end, opts, "[DEBUG] Clear Breakpoint")

keymap("n", "<leader>dB", function()
		local filetype = vim.api.nvim_buf_get_option(0, "filetype")
		if filetype == "rust" then
			if require("termdebug_helper").in_debug_session then
				vim.cmd("Break")
			else
				vim.notify("No Termdebug session running.")
			end
		else
			require 'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))
		end
	end, opts,
	"[DEBUG] Toggle Breakpoint (Conditioned)")

keymap("n", "<leader>dp", function()
		local filetype = vim.api.nvim_buf_get_option(0, "filetype")
		if filetype == "rust" then
			if require("termdebug_helper").in_debug_session then
				vim.cmd("Break")
			else
				vim.notify("No Termdebug session running.")
			end
		else
			require 'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))
		end
	end, opts,
	"[DEBUG] Toggle Breakpoint (Log message)")
keymap("n", "<leader>dr", ":lua require'dap'.repl.open()<CR>", opts, "[DEBUG] Open REPL")
keymap("n", "<F6>", ":lua require'dap'.run_last()<CR>", opts, "[DEBUG] Run last configuration")

keymap("n", "<F4>", ":lua require'dapui'.toggle()<CR>", opts, "[DEBUG] Toggle UI")
keymap("n", "<leader>dii", ":lua require'dapui'.eval(nil, {enter = true})<CR>", opts, "[DEBUG] Evaluate")
keymap("v", "<leader>dii", ":lua require'dapui'.eval(nil, {enter = true})<CR>", opts, "[DEBUG] Evaluate")
-- keymap("n", "<leader>diw", ":lua require'dap.ui.widgets'.hover('<cexpr', nil)<CR>", opts, "[DEBUG] Hover")
-- keymap("v", "<leader>diw", ":lua require'dap.ui.widgets'.hover('<cexpr>', nil)<CR>", opts, "[DEBUG] Hover")
keymap('n', '<Leader>die', ":lua require'dapui'.eval(vim.fn.input('[Expression] > '))<CR>", opts,
	"[DEBUG] Evaluate Expression")
-- require("dapui").eval(<expression>)
-- Cheatsheet
-- keymap("n", "<leader>?", ":Cheatsheet<cr>", opts)

-- lazygit
--keymap("n", "<leader>k", ":LazyGit<CR>", opts)

-- Toggleterm keybindings: see toggleterm.lua file
--keymap("n", "<leader>h", ":lua _HTOP_TOGGLE()<cr>", opts)
--keymap("n", "<leader>l", ":lua _LAZYGIT_TOGGLE()<cr>", opts)

-- Open links on gx (remap needed because nvim-tree overrides it)
-- xgd-open needs to be replaced with whatever you want to topen the link
keymap("n", "gx", ":execute '!xdg-open ' . shellescape(expand('<cfile>'), 1)<CR>", opts, "Open URL")

-- Define :Browse for tpope/vim-rhubarb since netrw is disabled
vim.cmd(":command! -nargs=1 Browse silent execute '!xdg-open ' . shellescape(<q-args>,1)")

keymap("n", "<leader>hg", nil, opts, "[VIM-RHUBARB]", false, true)
keymap("v", "<leader>hg", nil, opts, "[VIM-RHUBARB]", false, true)
keymap("n", "<leader>hgl", "<CMD>.GBrowse<CR>", opts, "[VIM-RHUBARB] Open current on Github")
keymap("n", "<leader>hgf", "<CMD>GBrowse<CR>", opts, "[VIM-RHUBARB] Open current file on Github")
keymap("n", "<leader>hgc", "<CMD>GcLog<CR>", opts, "[VIM-RHUBARB] Commit log")
keymap("v", "<leader>hgc", ":'<,'>GcLog<CR>", opts, "[VIM-RHUBARB] Show previous revisions of selected lines")
keymap("n", "<leader>hgb", "<CMD>Git blame<CR>", opts, "[VIM-FUGITIVE] Git Blame this file")
keymap("n", "<leader>hgd", "<CMD>Git difftool<CR>", opts, "[VIM-FUGITIVE] Git Diff Tool")
keymap("n", "<leader>hgm", "<CMD>Git mergetool<CR>", opts, "[VIM-FUGITIVE] Git Merge Tool")

-- vimspector keybindings
-- mnemonic 'di' = 'debug inspect' (pick your own, if you prefer!)
-- for normal mode - the word under the cursor
-- e.g.  vim.cmd("nmap <Leader>di <Plug>VimspectorBalloonEval")
-- vim.cmd("xmap <Leader>di <Plug>VimspectorBalloonEval")

--keymap("n", "<leader>di", "<Plug>VimspectorBalloonEval", term_opts)
--keymap("v", "<leader>di", "<Plug>VimspectorBalloonEval", term_opts)

-- Calendar keymap
-- keymap("n", "<leader>k", "<Plug>(calendar)", term_opts, "Open calendar")


--Vimwiki
keymap("n", "<leader>w", nil, opts, "[VIMWIKI]", false, true)

keymap("n", "<leader>v", ":Vista!!<CR>", opts, "Open/Close Vista")
-- Zen mode
keymap("n", "<leader><Space>", "<cmd>lua require'zen-mode'.toggle()<CR>", opts, "Zen-Mode")

-- Git Messenger (rhysd/git-messenger.vim)
keymap("n", "<leader>hh", "<Plug>(git-messenger)", opts, "[GIT-MESSENGER] Git Message (? for keybindings)", false, false)

-- Undotree
keymap("n", "<leader>u", ":UndotreeToggle<CR>", opts, "Undotree Toggle")
keymap("n", "<leader>U", ":UndotreeToggle<CR>", opts, "Undotree Toggle")

-- Turn editor transparent
keymap("n", "<leader>P", ":TransparentToggle<CR>", opts, "Transparent Toggle")

-- Remove search highlights
keymap("n", "<leader>l", nil, opts, "Search-Highlight Options", false, true)
keymap("n", "<leader>lt", ":set hls!<CR>", opts, "Toggle highlighting (:set hls!)") --Toggle instead

keymap("n", "<leader>ll", ":nohl<CR>:VMClear<CR>:lua print('Cleared search highlights')<CR>", opts,
	"Clear highlighting (:nohl)")


-- Unicode fuzzy search (see plugin unicode.vim)
keymap("i", "<C-G><C-F>", "<Plug>(UnicodeFuzzy)", opts, "[UNICODE] Insert Unicode Character")

keymap("n", "gk", ":lua require('neogen').generate()<CR>", opts, "[NEOGEN] Insert annotation")

-- trouble.nvim
keymap("n", "<leader>t", nil, opts, "[TROUBLE|TERMINAL]", false, true)
keymap("n", "<leader>tt", "<cmd>TroubleToggle<cr>", opts, "[TROUBLE] Toggle Trouble")
keymap("n", "<leader>tw", "<cmd>Trouble workspace_diagnostics<cr>", opts, "[TROUBLE] Workspace diagnostics")
keymap("n", "<leader>td", "<cmd>Trouble document_diagnostics<cr>", opts, "[TROUBLE] Document diagnostics")
keymap("n", "<leader>tl", "<cmd>Trouble loclist<cr>", opts, "[TROUBLE] Location list")
keymap("n", "<leader>tq", "<cmd>Trouble quickfix<cr>", opts, "[TROUBLE] Quickfix list")
keymap("n", "gR", "<cmd>Trouble lsp_references<cr>", opts, "[TROUBLE] LSP References")

keymap("n", "[d", '<cmd>lua vim.diagnostic.goto_prev({ border = "rounded" })<CR>', opts,
	"Goto previous diagnostic result", nil, nil)
keymap("n", "]d", '<cmd>lua vim.diagnostic.goto_next({ border = "rounded" })<CR>', opts, "Goto next diagnostic result"
, nil, nil)
keymap("n", "[q", '<cmd>cprevious<CR>', opts, "Jump to previous quickfix entry", nil, nil)
keymap("n", "]q", '<cmd>cnext<CR>', opts, "Jump to next quickfix entry", nil, nil)

-- center cursor after scrolling up/down
-- vim.api.nvim_set_keymap("n", "<C-u>", "<C-u>zz", { noremap = true })
-- vim.api.nvim_set_keymap("n", "<C-d>", "<C-d>zz", { noremap = true })

-- luasnip
-- keymap("i", "<tab>",
--   ":lua if require('luasnip').expand_or_jumpable() then require('luasnip').expand_or_jump() else vim.api.nvim_feedkeys('<Tab>', 'n') end"
--   , opts, "[LUASNIP] Expand or Jump", true, true)


-- " press <Tab> to expand or jump in a snippet. These can also be mapped separately
-- " via <Plug>luasnip-expand-snippet and <Plug>luasnip-jump-next.
vim.cmd [[imap <silent><expr> <Tab> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>' ]]
-- " -1 for jumping backwards.
vim.cmd [[inoremap <silent> <S-Tab> <cmd>lua require'luasnip'.jump(-1)<Cr>]]

vim.cmd [[snoremap <silent> <Tab> <cmd>lua require('luasnip').jump(1)<Cr>]]
vim.cmd [[snoremap <silent> <S-Tab> <cmd>lua require('luasnip').jump(-1)<Cr>]]

-- " For changing choices in choiceNodes (not strictly necessary for a basic setup).
vim.cmd [[imap <silent><expr> <C-E> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-E>']]
vim.cmd [[smap <silent><expr> <C-E> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-E>']]


-- keymap("n", "<leader>F", "<cmd>lua vim.lsp.buf.format()<CR>", opts, "Format file", nil, nil, bufnr)
vim.cmd([[:command! F lua vim.lsp.buf.format()]])


-- Register keymaps to legendary.nvim
-- this needs to be done after all keybindings are defined
local legendary = require('legendary')
legendary.setup({
	which_key = {
		auto_register = true,
		do_binding = false,
	},
	extensions = {
		-- load keymaps and commands from nvim-tree.lua
		nvim_tree = true,
		-- load keymaps from diffview.nvim
		diffview = true,
	},
})
