local status_ok, nvim_tree = pcall(require, "nvim-tree")
if not status_ok then
  vim.notify("nvim-tree not found")
  return
end

local config_status_ok, nvim_tree_config = pcall(require, "nvim-tree.config")
if not config_status_ok then
  vim.notify("nvim-tree.config not found")
  return
end

local tree_cb = nvim_tree_config.nvim_tree_callback

-- auto_close has been removed, this replaces it
-- vim.cmd [[autocmd BufEnter * ++nested if winnr('$') == 1 && bufname() == 'NvimTree_' .. tabpagenr() | quit | endif]]


local function open_nvim_tree(data)
  -- buffer is a [No Name]
  local no_name = data.file == "" and vim.bo[data.buf].buftype == ""

  -- buffer is a directory
  local directory = vim.fn.isdirectory(data.file) == 1

  if not directory then
    return
  end

  -- change to the directory
  if directory then
    vim.cmd.cd(data.file)
  end

  -- open the tree
  require("nvim-tree.api").tree.open()

end

vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })

nvim_tree.setup({
  disable_netrw = true,
  hijack_netrw = true,
  -- auto_close = true, -- removed, see command above
  auto_reload_on_write = true,
  open_on_tab = false,
  hijack_cursor = false,
  hijack_unnamed_buffer_when_opening = true,
  hijack_directories = {
    enable = false,
    auto_open = false,
  },
  diagnostics = {
    enable = true,
    icons = {
      hint = "",
      info = "",
      warning = "",
      error = "",
    },
  },
  update_focused_file = {
    enable = true,
    update_cwd = true,
    ignore_list = {},
  },
  filters = {
    dotfiles = false,
    custom = {},
    exclude = {},
  },
  git = {
    enable = true,
    ignore = true,
    timeout = 500,
  },
  view = {
    width = 30,
    -- height = 30,
    preserve_window_proportions = false,
    hide_root_folder = false,
    side = "left",
    mappings = {
      custom_only = false,
      list = {
        { key = { "l", "<CR>", "o" }, cb = tree_cb("edit") },
        { key = "h", cb = tree_cb("close_node") },
        { key = "v", cb = tree_cb("vsplit") },
      },
    },
    number = false,
    relativenumber = false,
    signcolumn = "yes",
  },
  renderer = {
    icons = {
      glyphs = {
        default = "",
        symlink = "",
        git = {
          unstaged = "",
          staged = "S",
          unmerged = "",
          renamed = "➜",
          deleted = "",
          untracked = "U",
          ignored = "◌",
        },
        folder = {
          default = "",
          open = "",
          empty = "",
          empty_open = "",
          symlink = "",
        },
      },
    },
  },
  actions = {
    change_dir = {
      enable = true,
      global = false,
    },
    open_file = {
      quit_on_open = true,
      resize_window = false,
      window_picker = {
        enable = true,
        chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
        exclude = {
          filetype = {
            "notify",
            "packer",
            "qf",
          },
        },
      },
    },
  },
  -- log = {
  --   enable = true,
  --   truncate = true,
  --   types = {
  --     git = true,
  --     profile = true,
  --   },
  -- },
})

vim.g.nvim_tree_git_hl = true
vim.g.disable_window_picker = true
vim.g.root_folder_modifier = ":t"
vim.g.show_icons = {
  git = 1,
  folders = 1,
  files = 1,
  folder_arrows = 1,
}
