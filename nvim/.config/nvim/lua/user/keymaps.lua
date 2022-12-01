local opts = { noremap = true, silent = true }
local term_opts = { silent = true }


-- shorten function name

local keymap = require("user.utilities").keymap
if keymap == nil then
  vim.notify("File keymaps.lua: Can't setup keymaps, error loading user.utilities")
  return
end

-- Remap space as leader key
-- no mapping to apply to all. see :help map-modes
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

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
keymap("n", "<leader>fw", "<cmd>Telescope lsp_workspace_symbols<CR>", opts, "Telescope workspace symbols")
keymap("n", "<leader>fs", "<cmd>Telescope lsp_document_symbols<CR>", opts, "Telescope workspace symbols")
keymap("n", "<leader>?", "<cmd>Telescope keymaps<CR>", opts, "Telescope keymaps")

-- default Live Grep
keymap("n", "<leader>g", nil, opts, "[GREP]", false, true)
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
  , opts, "Telescope live_grep (without RegEx)")

keymap(
  "n",
  "<leader>0",
  "<cmd>lua require'user.telescope-custom'.dot_files()<CR>",
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
  "<CMD>lua require'user.telescope-custom'.list_sessions()<CR>",
  opts,
  "Prosessions List"
)

keymap("n", "<leader>s", "<cmd>lua require'telescope.builtin'.current_buffer_fuzzy_find()<cr>", opts,
  "Telescope Fuzzy Buffer")

-- keymap("n", "<leader>s", "<cmd>lua require'telescope.builtin'.lsp_workspace_symbols()<cr>", opts)
keymap("n", "<leader>.", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts, "Code Actions")
keymap("v", "<leader>.", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts, "Code Actions")
-- remap to open the Telescope refactoring menu in visual mode
keymap("n", "<leader>rr", "<Esc><cmd>lua require('telescope').extensions.refactoring.refactors()<CR>", { noremap = true }
  , "Code Actions [Telescope]")
keymap("v", "<leader>rr", "<Esc><cmd>lua require('telescope').extensions.refactoring.refactors()<CR>", { noremap = true }
  , "Code Actions [Telescope]")


keymap("n", "<leader>dld", "<cmd>lua require'telescope.builtin'.diagnostics()<cr>", opts, "Telescope diagnostics")

-- Telescope DAP
keymap("n", "<leader>d", nil, opts, "[DEBUG]", false, true)
keymap("n", "<leader>dlb", ":Telescope dap list_breakpoints<CR>", opts, "List breakpoints")
keymap("n", "<leader>dlc", ":Telescope dap configurations<CR>", opts, "List configurations")
keymap("n", "<leader>dlx", ":Telescope dap commands<CR>", opts, "List commands")
keymap("n", "<leader>dlv", ":Telescope dap variables<CR>", opts, "List variables")
keymap("n", "<leader>dlf", ":Telescope dap frames<CR>", opts, "List frames")

keymap("n", "<F10>", ":lua require'dap'.step_over()<CR>", opts, "[DEBUG] Step Over")
keymap("n", "<F5>", ":lua require'dap'.continue()<CR>", opts, "[DEBUG] Continue")
keymap("n", "<F11>", ":lua require'dap'.step_into()<CR>", opts, "[DEBUG] Step Into")
keymap("n", "<F12>", ":lua require'dap'.step_out()<CR>", opts, "[DEBUG] Step Out")
keymap("n", "<leader>db", ":lua require'dap'.toggle_breakpoint()<CR>", opts, "[DEBUG] Toggle Breakpoint")
keymap("n", "<leader>dB", ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>", opts,
  "[DEBUG] Toggle Breakpoint (Conditioned)")
keymap("n", "<leader>lp", ":lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>", opts,
  "[DEBUG] Toggle Breakpoint (Log message)")
keymap("n", "<leader>dr", ":lua require'dap'.repl.open()<CR>", opts, "[DEBUG] Open REPL")
keymap("n", "<F6>", ":lua require'dap'.run_last()<CR>", opts, "[DEBUG] Run last configuration")

keymap("n", "<F4>", ":lua require'dapui'.toggle()<CR>", opts, "[DEBUG] Toggle UI")
keymap("n", "<leader>di", ":lua require'dapui'.eval(nil, {enter = true})<CR>", opts, "[DEBUG] Evaluate")
keymap("v", "<leader>di", ":lua require'dapui'.eval(nil, {enter = true})<CR>", opts, "[DEBUG] Evaluate")
-- keymap("n", "<leader>diw", ":lua require'dap.ui.widgets'.hover('<cexpr', nil)<CR>", opts, "[DEBUG] Hover")
keymap("v", "<leader>diw", ":lua require'dap.ui.widgets'.hover('<cexpr>', nil)<CR>", opts, "[DEBUG] Hover")
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
keymap("n", "gx", [[:execute '!xdg-open ' . shellescape(expand('<cfile>'), 1)<CR>]], opts, "Open URL")

-- vimspector keybindings
-- mnemonic 'di' = 'debug inspect' (pick your own, if you prefer!)
-- for normal mode - the word under the cursor
-- e.g.  vim.cmd("nmap <Leader>di <Plug>VimspectorBalloonEval")
-- vim.cmd("xmap <Leader>di <Plug>VimspectorBalloonEval")

--keymap("n", "<leader>di", "<Plug>VimspectorBalloonEval", term_opts)
--keymap("v", "<leader>di", "<Plug>VimspectorBalloonEval", term_opts)

-- Calendar keymap
-- keymap("n", "<leader>k", "<Plug>(calendar)", term_opts, "Open calendar")

keymap("n", "<leader>v", ":Vista!!<CR>", opts, "Open/Close Vista")
-- Zen mode
keymap("n", "<leader><SPACE>", "<cmd>lua require'zen-mode'.toggle()<CR>", opts, "Zen-Mode")

-- Undotree
keymap("n", "<leader>u", ":UndotreeToggle<CR>", opts, "Undotree Toggle")
keymap("n", "<leader>U", ":UndotreeToggle<CR>", opts, "Undotree Toggle")

-- Turn editor transparent
keymap("n", "<leader>P", ":TransparentToggle<CR>", opts, "Transparent Toggle")

-- Remove search highlights
keymap("n", "<leader>l", ":set hls!<CR>", opts, "Toggle highlighting (:set hls!)") --Toggle instead
keymap("n", "<leader>h", ":nohl<CR>:VMClear<CR>", opts, "Clear highlighting (:nohl)")
-- Vim Visual multi cursor keymaps
-- vim.g.VM_mouse_mappings = 1
-- vim.g.VM_theme = "sand"
vim.g.VM_highlight_matches = "red"
vim.g.VM_maps = {
  -- ["Find Under"] = "<C-d>",
  -- ["Find Subword Under"] = "<C-d>",
  ["Undo"] = "u",
  ["Redo"] = "<C-r>",
}

-- Unicode fuzzy search (see plugin unicode.vim)
keymap("i", "<C-G><C-F>", "<Plug>(UnicodeFuzzy)", opts, "Insert Unicode Character")

keymap("n", "gk", ":lua require('neogen').generate()<CR>", opts, "Insert annotation")

-- change github copilot keybindings
-- vim.cmd([[imap <silent><script><expr> <S-Right> copilot#Accept("\<CR>")]])
-- vim.g.copilot_no_tab_map = true


-- trouble.nvim
keymap("n", "<leader>t", nil, opts, "[TROUBLE|TERMINAL]", false, true)
keymap("n", "<leader>tt", "<cmd>TroubleToggle<cr>", opts, "[TROUBLE] Toggle Trouble")
keymap("n", "<leader>tw", "<cmd>Trouble workspace_diagnostics<cr>", opts, "[TROUBLE] Workspace diagnostics")
keymap("n", "<leader>td", "<cmd>Trouble document_diagnostics<cr>", opts, "[TROUBLE] Document diagnostics")
keymap("n", "<leader>tl", "<cmd>Trouble loclist<cr>", opts, "[TROUBLE] Location list")
keymap("n", "<leader>tq", "<cmd>Trouble quickfix<cr>", opts, "[TROUBLE] Quickfix list")
keymap("n", "gR", "<cmd>Trouble lsp_references<cr>", opts, "[TROUBLE] LSP References")


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
