local opts = { noremap = true, silent = true }
local term_opts = { silent = true }

-- shorten function name
local keymap = vim.api.nvim_set_keymap

-- Remap space as leader key
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
keymap("n", "<C-h>", "<C-w>h" , opts)
keymap("n", "<C-j>", "<C-w>j" , opts)
keymap("n", "<C-k>", "<C-w>k" , opts)
keymap("n", "<C-l>", "<C-w>l" , opts)

-- Replaced with nvim-tree
--keymap("n", "<leader>e", ":Lexplore 20<cr>", opts)
keymap("n", "<leader>e", ":NvimTreeToggle<cr>", opts)

-- Resize with arrows
keymap("n", "<C-Up>", ":resize +2<cr>", opts)
keymap("n", "<C-Down>", ":resize -2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize +2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize -2<CR>", opts)

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)

-- Insert --
-- Press jk fast to escape
keymap("i", "jk", "<ESC>", opts)

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

 -- Move text up and down
keymap("v", "<A-j>", ":m .+1<CR>==", opts)
keymap("v", "<A-k>", ":m .-2<CR>==", opts)
keymap("v", "p", '"_dP', opts)

-- Visual Block --
-- Move text up and down
keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)
keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)

-- Terminal --
-- Better terminal navigation
keymap("t", "<C-h>", "<C-\\><C-N><C-w>h", term_opts)
keymap("t", "<C-j>", "<C-\\><C-N><C-w>j", term_opts)
keymap("t", "<C-k>", "<C-\\><C-N><C-w>k", term_opts)
keymap("t", "<C-l>", "<C-\\><C-N><C-w>l", term_opts)

-- open terminal in split
keymap("n", "<leader>tv", ":vsplit | term<cr>:vertical resize 90<cr>i", opts)
keymap("n", "<leader>th", ":split | term<cr>:resize 15<cr>i", opts)
keymap("n", "<leader>x", ":bw<cr>", opts)
keymap("n", "<leader>X", ":bw!<cr>", opts)

--keymap("n", "<leader>f", "<cmd>Telescope find_files<cr>", opts)
keymap("n", "<leader>f", "<cmd>Telescope find_files<cr>", opts)
keymap("n", "<leader>dd", "<cmd>Telescope git_files<cr>", opts)
keymap("n", "<leader>b", ":Telescope buffers<cr><esc>", opts)
keymap("n", "<leader>?", ":Telescope keymaps<cr>", opts)

-- default Live Grep
keymap("n", "<leader>g", "<cmd>Telescope live_grep<cr>", opts)
-- Live Grep with hidden hiles
keymap("n", "<leader>GH", "<cmd>lua require'telescope.builtin'.live_grep({vimgrep_arguments={'rg', '--color=never', '--no-heading', '--with-filename', '--line-number', '--column', '--smart-case', '--hidden', '--trim'}})<cr>", opts)



keymap("n", "<leader>s", "<cmd>lua require'telescope.builtin'.current_buffer_fuzzy_find()<cr>", opts)
-- keymap("n", "<leader>s", "<cmd>lua require'telescope.builtin'.lsp_workspace_symbols()<cr>", opts)
keymap("n", "<leader>.", "<cmd>lua require'telescope.builtin'.lsp_code_actions()<cr><esc>", opts)

keymap("n", "<leader>dld", "<cmd>lua require'telescope.builtin'.diagnostics()<cr>", opts)

-- Telescope DAP
keymap("n", "<leader>dlb", ":Telescope dap list_breakpoints<CR>", opts)
keymap("n", "<leader>dlc", ":Telescope dap configurations<CR>", opts)
keymap("n", "<leader>dlx", ":Telescope dap commands<CR>", opts)
keymap("n", "<leader>dlv", ":Telescope dap variables<CR>", opts)
keymap("n", "<leader>dlf", ":Telescope dap frames<CR>", opts)

keymap("n","<F10>", ":lua require'dap'.step_over()<CR>", opts)
keymap("n","<F5>", ":lua require'dap'.continue()<CR>", opts)
keymap("n","<F11>", ":lua require'dap'.step_into()<CR>", opts)
keymap("n","<F12>", ":lua require'dap'.step_out()<CR>", opts)
keymap("n","<leader>db", ":lua require'dap'.toggle_breakpoint()<CR>", opts)
keymap("n","<leader>dB", ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>", opts)
keymap("n","<leader>lp", ":lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>", opts)
keymap("n","<leader>dr", ":lua require'dap'.repl.open()<CR>", opts)
keymap("n","<F6>", ":lua require'dap'.run_last()<CR>", opts)

keymap("n","<F4>", ":lua require'dapui'.toggle()<CR>", opts)
keymap("n", "<leader>di", ":lua require'dapui'.eval()<CR>", opts)
keymap("v", "<leader>di", ":lua require'dapui'.eval()<CR>", opts)

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
keymap("n","gx", [[:execute '!xdg-open ' . shellescape(expand('<cfile>'), 1)<CR>]], opts)

-- vimspector keybindings
-- mnemonic 'di' = 'debug inspect' (pick your own, if you prefer!)
-- for normal mode - the word under the cursor
-- e.g.  vim.cmd("nmap <Leader>di <Plug>VimspectorBalloonEval")
-- vim.cmd("xmap <Leader>di <Plug>VimspectorBalloonEval")

--keymap("n", "<leader>di", "<Plug>VimspectorBalloonEval", term_opts)
--keymap("v", "<leader>di", "<Plug>VimspectorBalloonEval", term_opts)

-- Calendar keymap
keymap("n", "<leader>k", "<Plug>(calendar)", term_opts)

-- Zen mode
keymap("n", "<leader><SPACE>","<cmd>lua require'zen-mode'.toggle()<CR>", opts)

-- Undotree
keymap("n", "<leader>u",":UndotreeToggle<CR>", opts)
keymap("n", "<leader>U",":UndotreeToggle<CR>", opts)

-- Turn editor transparent
keymap("n", "<leader>P",":TransparentToggle<CR>", opts)

-- Remove search highlights
keymap("n", "<leader>l",":set hls!<CR>", opts) --Toggle instead
keymap("n", "<leader>h",":nohl<CR>:VMClear<CR>", opts)
-- Vim Visual multi cursor keymaps
vim.g.VM_mouse_mappings = 1
vim.g.VM_theme = 'sand'
vim.g.VM_highlight_matches = 'red'
vim.g.VM_maps = {
  ['Find Under'] = '<C-d>',
  ['Find Subword Under'] = '<C-d>',
  ["Undo"] = 'u',
  ["Redo"] = '<C-r>'
}

-- change github copilot keybindings
vim.cmd [[imap <silent><script><expr> <S-Right> copilot#Accept("\<CR>")]]
vim.g.copilot_no_tab_map = true

