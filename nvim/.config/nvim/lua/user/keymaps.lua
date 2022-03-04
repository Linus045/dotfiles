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
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

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
keymap("n", "<leader>ts", ":vsplit | term<cr>:vertical resize 90<cr>i", opts)
keymap("n", "<leader>x", ":bw<cr>", opts)
keymap("n", "<leader>X", ":bw!<cr>", opts)

--keymap("n", "<leader>f", "<cmd>Telescope find_files<cr>", opts)
keymap("n", "<leader>ff", "<cmd>lua require'telescope.builtin'.find_files(require('telescope.themes').get_dropdown({ previewer = false }))<cr>", opts)
keymap("n", "<leader>fg", "<cmd>lua require'telescope.builtin'.git_files(require('telescope.themes').get_dropdown({ previewer = false }))<cr>", opts)
keymap("n", "<leader>G", "<cmd>Telescope live_grep<cr>", opts)
keymap("n", "<leader>b", ":Telescope buffers<cr>", opts)
keymap("n", "<leader>g", "<cmd>lua require'telescope.builtin'.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown({ previewer = false }))<cr>", opts)
keymap("n", "<leader>s", "<cmd>lua require'telescope.builtin'.lsp_workspace_symbols()<cr>", opts)
keymap("n", "<leader>.", "<cmd>lua require'telescope.builtin'.lsp_code_actions()<cr>", opts)

keymap("n", "<leader>dl", "<cmd>lua require'telescope.builtin'.diagnostics()<cr>", opts)

-- Cheatsheet
keymap("n", "<leader>?", ":Cheatsheet<cr>", opts)

-- lazygit
--keymap("n", "<leader>k", ":LazyGit<CR>", opts)

-- Toggleterm keybindings: see toggleterm.lua file
keymap("n", "<leader>h", ":lua _HTOP_TOGGLE()<cr>", opts)
keymap("n", "<leader>l", ":lua _LAZYGIT_TOGGLE()<cr>", opts)

-- Open links on gx (remap needed because nvim-tree overrides it)
-- xgd-open needs to be replaced with whatever you want to topen the link
keymap("n","<leader>gx", [[:execute '!xdg-open ' . shellescape(expand('<cfile>'), 1)<CR>]], opts)

-- WhichKey
keymap("n", "<leader>", ":WhichKey '<Space>'<CR>", opts)
keymap("v", "<leader>", "<c-u> :WhichKeyVisual '<Space>'<CR>", opts)

-- vimspector keybindings
-- mnemonic 'di' = 'debug inspect' (pick your own, if you prefer!)
-- for normal mode - the word under the cursor
-- vim.cmd("nmap <Leader>di <Plug>VimspectorBalloonEval")
-- vim.cmd("xmap <Leader>di <Plug>VimspectorBalloonEval")
keymap("n", "<leader>di", "<Plug>VimspectorBalloonEval", term_opts)
keymap("v", "<leader>di", "<Plug>VimspectorBalloonEval", term_opts)
