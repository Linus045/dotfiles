local status_ok, gitsigns = pcall(require, "gitsigns")
if not status_ok then
  vim.notify("gitsigns not found")
  return
end

local keymap = require("user.utilities").keymap
if keymap == nil then
  vim.notify("File keymaps.lua: Can't setup keymaps, error loading user.utilities")
  return
end

local function gitsigns_keymappings(bufnr)
  local function map(mode, lhs, rhs, opts)
    opts = vim.tbl_extend("force", { noremap = true, silent = true }, opts or {})
    vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
  end

  -- Navigation
  keymap("n", "]c", "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'", { expr = true }, "[GITSIGNS] Next Hunk", false, false
    ,
    bufnr)
  keymap("n", "[c", "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'", { expr = true }, "[GITSIGNS] Previous Hunk", false,
    false,
    bufnr)

  -- Actions
  opts = { noremap = true, silent = true }
  keymap("n", "<leader>h", nil, opts, "[GITSIGNS]", false, true)
  keymap("n", "<leader>hs", ":Gitsigns stage_hunk<CR>", opts, "[GITSIGNS] Stage hunk", false, false, bufnr)
  keymap("v", "<leader>hs", ":Gitsigns stage_hunk<CR>", opts, "[GITSIGNS] Stage hunk", false, false, bufnr)
  keymap("n", "<leader>hr", ":Gitsigns reset_hunk<CR>", opts, "[GITSIGNS] Reset hunk", false, false, bufnr)
  keymap("v", "<leader>hr", ":Gitsigns reset_hunk<CR>", opts, "[GITSIGNS] Reset hunk", false, false, bufnr)
  keymap("n", "<leader>hS", "<cmd>Gitsigns stage_buffer<CR>", opts, "[GITSIGNS] Stage current buffer", false, false,
    bufnr)
  keymap("n", "<leader>hu", "<cmd>Gitsigns undo_stage_hunk<CR>", opts, "[GITSIGNS] Undo stage hunk", false, false, bufnr)
  keymap("n", "<leader>hR", "<cmd>Gitsigns reset_buffer<CR>", opts, "[GITSIGNS] Reset buffer", false, false, bufnr)
  keymap("n", "<leader>hp", "<cmd>Gitsigns preview_hunk<CR>", opts, "[GITSIGNS] Preview Hunk", false, false, bufnr)
  keymap("n", "<leader>hb", '<cmd>lua require"gitsigns".blame_line{full=true}<CR>', opts, "[GITSIGNS] Blame line (full)"
    , false,
    false,
    bufnr)
  keymap("n", "<leader>htb", "<cmd>Gitsigns toggle_current_line_blame<CR>", opts, "[GITSIGNS] Toggle current line blame"
    , false, false,
    bufnr)
  keymap("n", "<leader>hth", "<cmd>Gitsigns toggle_linehl<CR>", opts, "[GITSIGNS] Toggle line highlights", false, false,
    bufnr)
  keymap("n", "<leader>htw", "<cmd>Gitsigns toggle_word_diff<CR>", opts, "[GITSIGNS] Toggle word diff"
    , false, false, bufnr)
  keymap("n", "<leader>hd", "<cmd>Gitsigns diffthis<CR>", opts, "[GITSIGNS] Diff this file", false, false, bufnr)
  keymap("n", "<leader>hD", '<cmd>lua require"gitsigns".diffthis("~")<CR>', opts, "[GITSIGNS] Diff this file ", false,
    false,
    bufnr)
  keymap("n", "<leader>htd", "<cmd>Gitsigns toggle_deleted<CR>", opts, "[GITSIGNS] Show/Hide deleted hunks", false, false
    ,
    bufnr)

  -- Text object
  keymap("o", "ih", ":<C-U>Gitsigns select_hunk<CR>", opts, "[GITSIGNS] Select Hunk", false, false, bufnr)
  keymap("x", "ih", ":<C-U>Gitsigns select_hunk<CR>", opts, "[GITSIGNS] Select Hunk", false, false, bufnr)
end

gitsigns.setup({
  signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
  numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
  linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
  word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
  watch_gitdir = {
    interval = 1000,
    follow_files = true,
  },
  attach_to_untracked = true,
  current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
    delay = 1000,
    ignore_whitespace = false,
  },
  current_line_blame_formatter = "<author>, <author_time:%d.%m.%Y> - <summary>",
  sign_priority = 6,
  update_debounce = 100,
  status_formatter = nil, -- Use default
  max_file_length = 40000,
  preview_config = {
    -- Options passed to nvim_open_win
    border = "single",
    style = "minimal",
    relative = "cursor",
    row = 0,
    col = 1,
  },
  yadm = {
    enable = false,
  },
  on_attach = gitsigns_keymappings,
})
