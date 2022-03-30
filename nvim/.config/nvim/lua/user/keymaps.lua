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
keymap("n", "<leader>ff", "<cmd>Telescope find_files<cr>", opts)
keymap("n", "<leader>dd", "<cmd>Telescope git_files<cr>", opts)
keymap("n", "<leader>b", ":Telescope buffers<cr><esc>", opts)

-- default Live Grep
keymap("n", "<leader>g", "<cmd>Telescope live_grep<cr>", opts)
-- Live Grep with hidden hiles
keymap("n", "<leader>GH", "<cmd>lua require'telescope.builtin'.live_grep({vimgrep_arguments={'rg', '--color=never', '--no-heading', '--with-filename', '--line-number', '--column', '--smart-case', '--hidden'}})<cr>", opts)



keymap("n", "<leader>s", "<cmd>lua require'telescope.builtin'.current_buffer_fuzzy_find()<cr>", opts)
-- keymap("n", "<leader>s", "<cmd>lua require'telescope.builtin'.lsp_workspace_symbols()<cr>", opts)
keymap("n", "<leader>.", "<cmd>lua require'telescope.builtin'.lsp_code_actions()<cr><esc>", opts)

keymap("n", "<leader>dl", "<cmd>lua require'telescope.builtin'.diagnostics()<cr>", opts)

-- Cheatsheet
keymap("n", "<leader>?", ":Cheatsheet<cr>", opts)

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
-- vim.cmd("nmap <Leader>di <Plug>VimspectorBalloonEval")
-- vim.cmd("xmap <Leader>di <Plug>VimspectorBalloonEval")
keymap("n", "<leader>di", "<Plug>VimspectorBalloonEval", term_opts)
keymap("v", "<leader>di", "<Plug>VimspectorBalloonEval", term_opts)


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
-- keymap("n", "<leader>l",":set hls!<CR>", opts) --Toggle instead
keymap("n", "<leader>l",":nohl<CR>", opts)



-- Rename with window: https://www.reddit.com/r/neovim/comments/nsfv7h/rename_in_floating_window_with_neovim_lsp/
local function dorename(win)
  local new_name = vim.trim(vim.fn.getline('.'))
  vim.api.nvim_win_close(win, true)
  vim.lsp.buf.rename(new_name)
end

local function rename()
  local opts = {
    relative = 'cursor',
    row = 0,
    col = 0,
    width = 30,
    height = 1,
    style = 'minimal',
    border = 'single'
  }
  local cword = vim.fn.expand('<cword>')
  local buf = vim.api.nvim_create_buf(false, true)
  local win = vim.api.nvim_open_win(buf, true, opts)
  local fmt =  '<cmd>lua Rename.dorename(%d)<CR>'

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, {cword})
  vim.api.nvim_buf_set_keymap(buf, 'i', '<CR>', string.format(fmt, win), {silent=true})
end

_G.Rename = {
   rename = rename,
   dorename = dorename
}
vim.api.nvim_set_keymap('n', '<leader>rn', '<cmd>lua Rename.rename()<CR>', {silent = true})

